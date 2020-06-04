# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Registries

      # Create a Feature
      class Create
        send(:include, Dry::Monads[:result, :do])

        def call(path:, registry:)
          file_io         = yield read(path)
          params          = yield deserialize(file_io)
          feature_hashes  = yield serialize(params)
          features        = yield create(feature_hashes)
          container       = yield register(features, registry)
          
          Success(container)
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
          features = feature_hashes.collect do |feature_hash|
            feature = ResourceRegistry::Operations::Features::Create.new.call(feature_hash)
            
            if feature.success?
              feature.value!
            else
              raise "Failed to create feature with #{feature.failure.errors.inspect}"
            end
          end

          Success(features)

          rescue Exception => e
            raise "Error occurred while creating features using #{feature_hashes}. " \
                  "Error: #{e.message}"
        end

        def register(features, registry)
          features.each do |feature|
            if defined?(Rails) && registry.db_connection&.table_exists?(:resource_registry_features)
              if ResourceRegistry::ActiveRecord::Feature.where(key: feature.key).blank?
                ResourceRegistry::ActiveRecord::Feature.new(feature.to_h).save
              end
            end
            
            registry.register_feature(feature)
          end
          
          Success(registry)
        end
      end
    end
  end
end