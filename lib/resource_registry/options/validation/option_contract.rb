require 'dry/validation'
require 'resource_registry/registries/validation/registry_contract'

module ResourceRegistry
  module Options
    module Validation
      class OptionContract < ResourceRegistry::Validation::ApplicationContract

        params do
          required(:key).filled(:string)
          optional(:settings).array(type?: SettingSchema)
          optional(:namespaces).array(type?: OptionSchema)
        end
      end
    end
  end
end