# frozen_string_literal: true

module ResourceRegistry
  module Validation

    # Schema and validation rules for the {ResourceRegistry::Feature} domain model
    class FeatureContract < ResourceRegistry::Validation::ApplicationContract

      # @!method call(params)
      # @param [Symbol] key (required)
      # @param [Bool] is_enabled (required)
      # @param [Array<Symbol>] namespace (optional)
      # @param [Any] item (optional)
      # @param [Hash] options (optional)
      # @param [ResourceRegistry::Meta] meta (optional)
      # @param [Array<ResourceRegistry::Setting>] settings (optional)
      # @return [Dry::Monads::Result::Success] if params pass validation
      # @return [Dry::Monads::Result::Failure] if params fail validation
      params do
        required(:key).value(:symbol)
        required(:namespace).maybe(:array)
        required(:is_enabled).value(:bool)
        optional(:item).value(:any)
        optional(:options).maybe(:hash)

        optional(:meta).maybe(:hash)
        optional(:settings).array(:hash)

        before(:value_coercer) do |result|
          result.to_h.merge({
                              key: result[:key]&.to_sym,
                              meta: result[:meta]&.symbolize_keys,
                              settings: (result[:settings]&.map(&:deep_symbolize_keys) || []),
                              namespace: result[:namespace]&.map(&:to_sym)
                            })
        end
      end
    end
  end
end
