require 'dry/validation'
require 'resource_registry/registries/validation/registry_contract'

module ResourceRegistry
  module Options
    module Validation
      class SettingContract < ResourceRegistry::Validation::ApplicationContract

        params do
          required(:key).filled(Dry::Types["string"] | Dry::Types["symbol"])
          required(:default).filled(:any)
          optional(:title).filled(:string)
          optional(:description).filled(:string)
          optional(:type).filled(Dry::Types["string"] | Dry::Types["symbol"])
          optional(:value).filled(:any)
        end

      end
    end
  end
end