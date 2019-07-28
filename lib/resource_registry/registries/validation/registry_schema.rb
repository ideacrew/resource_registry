require 'resource_registry/validation/application_schema'
require 'resource_registry/entities/options'

module ResourceRegistry
  module Registries
    module Validation
      class RegistrySchema < ResourceRegistry::Validation::ApplicationSchema

        Serializers     = Types::String.default('yaml_serializer'.freeze).enum('yaml_serializer', 'xml_serializer')
        Stores          = Types::String.default('file_store'.freeze).enum('file_store')

        Schema = Dry::Schema.Params do
          required(:config).hash do
            # registry_name
            required(:name).filled(:string)
            required(:root).filled(type?: Pathname)
            required(:env).filled(:string)

            optional(:default_namespace).filled(:string)
            optional(:system_dir).filled(:string)
            optional(:load_path).filled(:string)
            optional(:auto_register).array(:str?)
          end

          # required(:app_name).filled(:string)
          optional(:timestamp).filled(:str?)

          required(:persistence).hash do
            # required(:store).filled(:Stores)
            optional(:serializer).filled(Types::Serializers)
            # required(:serializer).filled(Dry::Types['Serializers'])
            required(:container).filled(:string)
          end

          optional(:options).filled(type?: ResourceRegistry::Entities::Options)
        end

      end
    end
  end
end