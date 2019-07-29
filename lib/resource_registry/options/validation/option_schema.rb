module ResourceRegistry
  module Options
    class OptionSchema < ResourceRegistry::Validation::ApplicationSchema

      required(:key).filled(:string)
      optional(:settings).array(type?: SettingSchema)
      optional(:namespaces).array(type?: OptionSchema)
    end
  end
end