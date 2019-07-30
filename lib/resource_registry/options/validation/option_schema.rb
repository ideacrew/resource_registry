module ResourceRegistry
  module Options
    module Validation
      class OptionSchema < ResourceRegistry::Validation::ApplicationSchema

        define do
          required(:key).filled(:symbol)
          optional(:settings).array(type?: SettingSchema)
          optional(:namespaces).array(type?: OptionSchema)
        end
      end
    end
  end
end