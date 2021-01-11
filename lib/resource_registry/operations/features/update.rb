# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      # Create a Feature
      class Update
        send(:include, Dry::Monads[:result, :do])

        def call(params)
          registry = params[:registry]

          feature_params  = yield build_params(params[:feature].to_h)
          entity          = yield create_entity(feature_params)
          feature         = yield save_record(entity) if defined? Rails
          updated_feature = yield update_registry(entity, registry)

          Success(feature)
        end

        private

        def build_params(params)
          feature_params = params.deep_symbolize_keys
          feature_params[:namespace_path] = {path: params.delete(:namespace)&.split('.')} if params[:namespace].present?
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

        def save_record(entity)
          ResourceRegistry::Stores.persist(entity) || Success(entity)
        end

        def update_registry(entity, registry)
          ResourceRegistry::Stores::Container::Update.new.call(entity, registry)
        end
      end
    end
  end
end