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
          registry        = yield save_and_register_feature(features, registry)
          namespaces      = yield build_namespaces(features)

          Success(namespace_list: namespaces, registry: registry)
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

        def save_and_register_feature(features, registry)
          features.each do |feature|
            ResourceRegistry::Stores.persist(feature) if defined? Rails
            registry.register_feature(feature)
          end

          Success(registry)
        end

        def build_namespaces(features)
          Try {
            features.collect do |feature|
              namespace = ResourceRegistry::Operations::Namespaces::Build.new.call(feature)
              namespace.success if namespace.success?
            end.compact
          }.to_result
        end
      end
    end
  end
end
