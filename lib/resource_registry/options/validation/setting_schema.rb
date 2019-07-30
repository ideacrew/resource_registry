module ResourceRegistry
  module Options
    module Validation
      class SettingSchema < ResourceRegistry::Validation::ApplicationSchema

        define do
          required(:key).filled(:symbol)
          required(:default).filled(:any)
          optional(:title).filled(:string)
          optional(:description).filled(:string)
          optional(:type).filled(:string)
          optional(:value).filled(:any)
        end
      end
    end
  end
end
