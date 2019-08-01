require 'dry/validation'

module ResourceRegistry
  module Registries
    module Validation
      class RegistryContract < ResourceRegistry::Validation::ApplicationContract

        Environments  = Types::String.default('development'.freeze).enum('development', 'test', 'production')
        Serializers   = Types::String.default('yaml_serializer'.freeze).enum('yaml_serializer', 'xml_serializer')
        Stores        = Types::String.default('file_store'.freeze).enum('file_store')

        params do
          required(:config).hash do
            # registry_name
            required(:name).filled(:string)
            required(:root).filled(type?: Pathname)
            # required(:env).filled(Environments)

            optional(:default_namespace).filled(:string)
            optional(:system_dir).filled(:string)
            optional(:load_path).filled(:string)
            optional(:auto_register).array(:str?)
          end

          # required(:app_name).filled(:string)
          optional(:timestamp).filled(:str?)
          optional(:load_paths).array(:str?)
          # required(:persistence).hash do
          #   required(:store).filled(Stores)
          #   optional(:serializer).filled(Serializers)
          #   required(:container).filled(:string)
          # end

          optional(:options).filled(type?: ResourceRegistry::Entities::Option)
        end

        # Path name must exist
        rule([:config, :root]) do
          Pathname(value).realpath rescue key.failure('pathname must exist')
        end

      end
    end
  end
end