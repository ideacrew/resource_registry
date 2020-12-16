# frozen_string_literal: true

module ResourceRegistry
  module Validation
    # Schema and validation rules for the {ResourceRegistry::Namespace} domain model
    class NamespaceContract < ResourceRegistry::Validation::ApplicationContract

      # @!method call(opts)
      # @param [Hash] opts the parameters to validate using this contract
      # @option opts [Symbol] :key required
      # @option opts [Array<Symbol>] :path required
      # @option opts [ResourceRegistry::Meta] :meta optional
      # @option opts [Array<Symbol>] :feature_keys optional
      # @option opts [Array<Hash>] :features optional
      # @option opts [Array<Hash>] :namespaces optional
      # @return [Dry::Monads::Result::Success] if params pass validation
      # @return [Dry::Monads::Result::Failure] if params fail validation
      params do
        required(:key).value(:symbol)
        required(:path).array(:symbol)
        optional(:meta).maybe(:hash)
        optional(:feature_keys).array(:symbol)
        optional(:features).array(:hash)
        optional(:namespaces).array(:hash)
      end

      rule(:features).each do
        if key? && value
          result = ResourceRegistry::Validation::FeatureContract.new.call(value)
          key.failure(text: "invalid feature", error: result.errors.to_h) if result && result.failure?
        end
      end

      rule(:namespaces).each do
        if key? && value
          result = ResourceRegistry::Validation::NamespaceContract.new.call(value)
          key.failure(text: "invalid namespace", error: result.errors.to_h) if result && result.failure?
        end
      end
    end
  end
end