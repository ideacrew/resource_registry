require 'dry/validation'
require 'resource_registry/registries/validation/registry_contract'

module ResourceRegistry
  module Options
    module Validation
      class SettingContract < ResourceRegistry::Validation::ApplicationContract

        params do
          required(:key).filled(type?: Symbol)
          required(:default).filled(:str?)
          optional(:title).maybe(:str?)
          optional(:description).maybe(:str?)
          optional(:type).maybe(:str?)
          optional(:value).maybe(:str?)
        end

      end
    end
  end
end