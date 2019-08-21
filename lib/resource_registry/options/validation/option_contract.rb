# frozen_string_literal: true

module ResourceRegistry
  module Options
    module Validation
      OptionContract = ResourceRegistry::Validation::ApplicationContract.build do

        params do
          required(:key).value(:symbol)

          optional(:settings).array(:hash) do
            required(:key).value(:symbol)
            required(:default).filled(:any)
            optional(:title).maybe(:string)
            optional(:description).maybe(:string)
            optional(:type).maybe(:symbol)
            optional(:value).maybe(:string)
          end

          optional(:namespaces).array(:hash)
        end
      end
    end
  end
end
