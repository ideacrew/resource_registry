# frozen_string_literal: true

module ResourceRegistry
  module Validation
    module Options
      class OptionContract < ResourceRegistry::Validation::ApplicationContract

        params do
          required(:key).value(:symbol)

          optional(:settings).array(:hash) do
            # required(:key).maybe(:symbol)
            required(:default).filled(:any)
            optional(:title).maybe(:string)
            optional(:description).maybe(:string)
            optional(:type).maybe(:symbol)
            optional(:value).maybe(:any)
            optional(:options).maybe(:array)
          end
        end

        rule([:settings, :options]) do
          if key? && value

            value.each do |var|
              result = OptionContract.new.call({:key => var[:key], :value => var[:value]})
              key.failure(text: "invalid namespace", error: result.errors.to_h) if result && result.failure?
            end

          end
        end

      end
    end
  end
end
