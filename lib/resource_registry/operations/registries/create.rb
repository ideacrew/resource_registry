# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Registries

      # Create a Feature
      class Create
        send(:include, Dry::Monads[:result, :do])

        def call(path:, registry:)
          file_io   = yield read(path)
          params    = yield deserialize(file_io)
          features  = yield serialize(params)
          container = yield register(features, registry)
          
          Success(container)
        end

        private 

        def read(path)
          file_io = ResourceRegistry::Stores::File::Read.new.call(path)

          Success(file_io)
        end

        def deserialize(file_io)
          params = ResourceRegistry::Serializers::Yaml::Deserialize.new.call(file_io.value!)

          Success(params)
        end

        def serialize(params)
          features = ResourceRegistry::Serializers::Features::Serialize.new.call(params.value!)
        end

        def register(features, registry)
          features.each {|feature| registry.register(feature) }
          
          Success(registry)
        end
      end
    end
  end
end