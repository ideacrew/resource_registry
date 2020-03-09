# frozen_string_literal: true

module ResourceRegistry
  module Validation

    # Schema and validation rules for the {ResourceRegistry::Setting} domain model
    class SettingContract < ResourceRegistry::Validation::ApplicationContract

      # @!method call(params)
      # @param [Symbol] key required
      # @param [Any] item optional
      # @param [Hash] options optional
      # @param [ResourceRegistry::Meta] meta optional
      # @return [Dry::Monads::Result::Success] if params pass validation
      # @return [Dry::Monads::Result::Failure] if params fail validation
      params do
        required(:key).value(:symbol)
        required(:item).filled(:any)
        optional(:options).maybe(:hash)
        optional(:meta).maybe(:hash)

        before(:value_coercer) do |result|
          result.to_h.merge({meta: result[:meta].symbolize_keys}) if result[:meta].is_a? Hash
        end
      end

      rule(:meta) do
        if key? && value
          result = ResourceRegistry::Validation::MetaContract.new.call(value)
          # Use dry-validation metadata error form to pass error hash along with text to calling service
          key.failure(text: "invalid meta", error: result.errors.to_h) if result && result.failure?
        end
      end
    end
  end
end
