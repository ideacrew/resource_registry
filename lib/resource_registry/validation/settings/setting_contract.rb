# frozen_string_literal: true

module ResourceRegistry
  module Validation
    module Settings
      class SettingContract < ResourceRegistry::Validation::ApplicationContract

        # @!method call(params)
        # @param params [Hash] options used to create the contract
        #   @options params [Symbol] :key (required)
        #   @options params [Any] :item (optional)
        #   @options params [Hash] :options (optional)
        #   @options params [ResourceRegistry::Entities::Meta] :meta (optional)
        #   @return [Dry::Monads::Result::Success, Dry::Monads::Result::Failure]
        params do
          required(:key).value(:symbol)
          required(:item).filled(:any)
          optional(:options).maybe(:hash)
          optional(:meta).maybe(:hash)
        end

        rule(:meta) do
          if key? && value
            result = ResourceRegistry::Validation::Metas::MetaContract.new.call(value)

            # Use dry-validation metadata error form to pass error hash along with text to calling service
            key.failure(text: "invalid meta", error: result.errors.to_h) if result && result.failure?
          end
        end

      end
    end
  end
end
