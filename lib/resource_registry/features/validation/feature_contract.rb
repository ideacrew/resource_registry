module ResourceRegistry
  module Features
    module Validation

      FeatureContract = ResourceRegistry::Validation::ApplicationContract.build do
        
        params do
          required(:key).value(:symbol)
          required(:is_required).value(:bool)
          required(:is_enabled).value(:bool)
          optional(:alt_key).value(:symbol)
          optional(:title).maybe(:string)
          optional(:description).maybe(:string)
          optional(:registry).value(:hash)
          optional(:options).array(:hash)
          optional(:features).array(:hash)
        end
      end
    end
  end
end