module ResourceRegistry
  module Registries
    module Validation
      class RegistrySchema < AppSchema

        define do
          required(:config).hash do
            optional(:registry_name).filled(:string)
            optional(:root).filled(:string)
            required(:name).filled(:string)
            optional(:default_namespace).filled(:string)
            optional(:env).filled(:string)
            required(:system_dir).filled(:string)
            optional(:auto_register).array(:str?)
          end
          
          optional(:app_name).filled(:string)
          optional(:load_paths).array(:str?)
          optional(:timestamp).filled(:string)

          required(:persistence).hash do
            required(:store).filled(:string)
            required(:serializer).filled(:string)
            required(:container).filled(:string)
          end

          # required(:options).array do
          # end
        end
      end
    end
  end
end