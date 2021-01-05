# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Registries
      # Create a Feature
      class Create
        send(:include, Dry::Monads[:result, :do, :try])

        def call(path:, registry:)
          file_io         = yield read(path)
          params          = yield deserialize(file_io)
          feature_hashes  = yield serialize(params)
          features        = yield create(feature_hashes)
          values          = yield register_features(features, registry)

          Success(values)
        end

        private

        def read(path)
          file_io = ResourceRegistry::Stores::File::Read.new.call(path)

          if file_io.success?
            Success(file_io.value!)
          else
            Failure("File read failed!!")
          end
        end

        def deserialize(file_io)
          params = ResourceRegistry::Serializers::Yaml::Deserialize.new.call(file_io)

          if params.success?
            Success(params.value!)
          else
            Failure("Yaml deserialize failied!!")
          end
        end

        def serialize(params)
          feature_hashes = ResourceRegistry::Serializers::Features::Serialize.new.call(params)

          if feature_hashes.success?
            Success(feature_hashes.value!)
          else
            Failure("Feature serialize failed!!")
          end
        end

        def create(feature_hashes)
          Try {
            feature_hashes.collect do |feature_hash|
              result = ResourceRegistry::Operations::Features::Create.new.call(feature_hash)
              return result if result.failure?
              result.value!
            end
          }.to_result
        end

        def register_features(features, registry)
          namespaces = []
          features.each do |feature|
            persist_to_dbms(feature, registry) if defined? Rails
            registry.register_feature(feature)
            namespaces << feature_to_namespace(feature) if %w[feature_list nav].include?(feature.namespace_path.meta&.content_type.to_s) && feature.meta&.label.present?
          end

          Success({namespace_list: namespaces, registry: registry})
        end

        def feature_to_namespace(feature)
          {
            key: feature.namespace_path.path.map(&:to_s).join('_'),
            path: feature.namespace_path.path,
            feature_keys: [feature.key],
            meta: feature.namespace_path.meta.to_h
          }
        end

        def persist_to_dbms(feature, registry)
          if defined?(ResourceRegistry::Mongoid)
            ResourceRegistry::Stores::Mongoid::Persist.new.call(feature, registry)
          else
            # ResourceRegistry::Stores::ActiveRecord::Persist.new.call(feature, registry)
          end
        end
      end
    end
  end
end
