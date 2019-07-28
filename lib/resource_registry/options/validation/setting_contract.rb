require 'dry/validation'
require 'resource_registry/registries/validation/registry_contract'

module ResourceRegistry
  module Options
    module Validation
      class SettingContract < ResourceRegistry::Validation::ApplicationContract

        params do
          required(:key).filled(:symbol)
          required(:default).filled(:string)
          optional(:title).filled(:string)
          optional(:description).filled(:string)
          optional(:type).filled(:string)
          optional(:value).filled(:string)
        end

      end
    end
  end
end