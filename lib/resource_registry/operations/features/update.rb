# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features

      # Create a Feature
      class Update
        send(:include, Dry::Monads[:result, :do])

        def call(params)

          feature_params = yield build_params(params.to_h)
          feature_entity = yield create_entity(feature_params)
          feature        = yield update(feature_entity)

          Success(feature)
        end

        private

        def build_params(params)
          feature_params = params.deep_symbolize_keys

          feature_params[:settings] = feature_params[:settings].collect do |setting_hash|
            {key: setting_hash[0], item: setting_hash[1]}
          end

          Success(feature_params)
        end

        def create_entity(params)
          ResourceRegistry::Operations::Features::Create.new.call(params)
        end

        def update(feature_entity)
          feature = ResourceRegistry::ActiveRecord::Feature.where(key: feature_entity.key).first
          
          feature_entity.settings.each do |setting_entity|
            feature.update(is_enabled: feature_entity.is_enabled)
            setting = feature.settings.where(key: setting_entity.key).first
            setting.update(item: setting_entity.item)
          end

          Success(feature)
        end
      end
    end
  end
end