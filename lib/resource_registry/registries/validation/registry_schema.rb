module ResourceRegistry
  module Validation
    class RegistrySchema < AppSchema

      required(:registry_name).filled(:string)
      required(:root).filled(:string)
      required(:name).filled(:string)
      required(:default_namespace).filled(:string)
      required(:app_name).filled(:string)
      required(:env).filled(:string)
      required(:system_dir).filled(:string)
      required(:load_paths).maybe.array(:str?)
      required(:auto_register).maybe.array(:str?)
      required(:timestamp).maybe(:string)

      required(:persistence).hash do
        required(:store).filled(:string)
        required(:serilizer).filled(:string)
        required(:container).filled(:string)
      end

      required(:options).array do
      end

    end
  end
end