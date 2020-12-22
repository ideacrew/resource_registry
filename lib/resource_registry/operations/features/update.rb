# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      # Create a Feature
      class Update
        send(:include, Dry::Monads[:result, :do])

        def call(params)
          registry = params[:registry]

          feature_params = yield build_params(params[:feature].to_h)
          feature_entity = yield create_entity(feature_params)
          feature        = yield update_model(feature_entity)
          yield update_registry(feature_entity, registry)

          Success(feature)
        end

        private

        def build_params(params)
          feature_params = params.deep_symbolize_keys
          feature_params[:namespace_path] = {path: params.delete(:namespace).split('.')}
          feature_params[:settings] = feature_params[:settings].collect do |setting_hash|
            if setting_hash.is_a?(Hash)
              {key: setting_hash.keys[0], item: setting_hash.values[0]}
            else
              {key: setting_hash[0], item: setting_hash[1]}
            end
          end

          Success(feature_params)
        end

        def create_entity(params)
          ResourceRegistry::Operations::Features::Create.new.call(params)
        end

        def update_model(feature_entity)
          if defined?(Rails)
            feature = model_class.where(key: feature_entity.key).first
            feature.is_enabled = feature_entity.is_enabled

            feature_entity.settings.each do |setting_entity|
              if setting = feature.settings.detect{|setting| setting.key == setting_entity.key}
                setting.item = setting_entity.item
              else
                feature.settings.build(setting_entity.to_h)
              end
            end
            feature.save

            Success(feature)
          else
            Success(feature_entity)
          end
        end

        def model_class
          return ResourceRegistry::Mongoid::Feature if defined? ResourceRegistry::Mongoid
          ResourceRegistry::ActiveRecord::Feature
        end

        def update_registry(new_feature, registry)
          registered_feature_hash = registry[new_feature.key].feature.to_h
          registered_feature_hash[:is_enabled] = new_feature.is_enabled

          new_feature.settings.each do |setting|
            registered_feature_hash[:settings].each do |setting_hash|
              setting_hash[:item] = setting.item if setting.key == setting_hash[:key]
            end
          end

          updated_feature = ResourceRegistry::Operations::Features::Create.new.call(registered_feature_hash).value!

          registry.swap_feature(updated_feature)

          Success(updated_feature)
        end
      end
    end
  end
end
