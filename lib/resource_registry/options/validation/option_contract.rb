require 'dry/validation'
require 'resource_registry/registries/validation/registry_contract'

module ResourceRegistry
  module Options
    module Validation
      class OptionContract < ResourceRegistry::Validation::ApplicationContract

        required(:namespace).filled(:string)
        required(:key).filled(:string)
        required(:settings).maybe(:array)
        required(:namespaces).maybe(:hash)

      end
    end
  end
end