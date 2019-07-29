module ResourceRegistry
  module Options
    module Validation
      class SettingSchema < ResourceRegistry::Validation::ApplicationSchema

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
