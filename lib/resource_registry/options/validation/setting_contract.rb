require 'dry/validation'
require 'resource_registry/registries/validation/registry_contract'

module ResourceRegistry
  module Options
    module Validation
      class SettingContract < ResourceRegistry::Validation::ApplicationContract

        required(:key).filled(:symbol)
        required(:title).maybe(:string)
        required(:description).maybe(:string)
        required(:type).maybe(:string)
        required(:default).maybe(:string)
        required(:value).filled(:string)

      end
    end
  end
end