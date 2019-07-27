module ResourceRegistry
  module Registries
    module Validation
      class SettingSchema < AppSchema

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