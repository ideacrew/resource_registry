# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      # Create a Feature
      class Update
        send(:include, Dry::Monads[:result, :do])

        def call(params)
          feature_params  = yield build_params(params[:feature].to_h, params[:registry])
          entity          = yield create_entity(feature_params)
          feature         = yield save_record(entity, params[:registry], params[:filter]) if defined? Rails
          updated_feature = yield update_registry(entity, params[:registry])

          Success(entity)
        end

        private

        def build_params(params, registry)
          return feature_toggle_params(params, registry) if params[:toggle_feature]

          feature_params = params.deep_symbolize_keys
          feature_params[:namespace_path] = {path: params.delete(:namespace)&.split('.')} if params[:namespace].present?
          feature_params[:settings] = feature_params[:settings]&.collect do |setting_hash|
            if setting_hash.is_a?(Hash)
              {key: setting_hash.keys[0], item: setting_hash.values[0]}
            else
              {key: setting_hash[0], item: setting_hash[1]}
            end
          end
          feature_params[:settings] ||= []

          Success(feature_params)
        end

        def feature_toggle_params(params, registry)
          feature_params = ResourceRegistry::Stores.find(params[:key])&.success&.attributes&.deep_symbolize_keys
          feature_params ||= registry[params[:key]].feature.to_h
          feature_params[:is_enabled] = params[:is_enabled]

          Success(feature_params)
        end

        def create_entity(params)
          ResourceRegistry::Operations::Features::Create.new.call(params)
        end

        def save_record(entity, registry, filter_params = nil)
          ResourceRegistry::Stores.persist(entity, registry, {filter: filter_params}) || Success(entity)
        end

        def update_registry(entity, registry)
          return Success(entity) if registry[entity.key].meta&.content_type == :model_attributes
          ResourceRegistry::Stores::Container::Update.new.call(entity, registry)
        end
      end
    end
  end
end