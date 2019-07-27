module ResourceRegistry
  module Registries
    module Validation
      class OptionsSchema < AppSchema

        required(:namespace).filled(:string)
        required(:key).filled(:string)
        required(:settings).maybe(:array)
        required(:namespaces).maybe(:hash)

      end
    end
  end
end