require 'resource_registry/options/validation/setting_contract'

module ResourceRegistry
  module Options
    module Validation
      class OptionContract < ResourceRegistry::Validation::ApplicationContract

        params do
          required(:key).filled(:symbol)
          optional(:settings).array(type?: SettingContract)
          optional(:namespaces).array(type?: OptionContract)
        end
      end
    end
  end
end