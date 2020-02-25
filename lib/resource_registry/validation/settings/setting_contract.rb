# frozen_string_literal: true

module ResourceRegistry
  module Validation
    module Settings
      class SettingContract < ResourceRegistry::Validation::ApplicationContract

        params do
          required(:key).value(:symbol)
          required(:value).filled(:any)
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
