# frozen_string_literal: true

module ResourceRegistry
  module Validation
    # Schema and validation rules for the {ResourceRegistry::Namespace} domain model
    class NamespacePathContract < ResourceRegistry::Validation::ApplicationContract

      # @!method call(opts)
      # @param [Hash] opts the parameters to validate using this contract
      # @option opts [Array<Symbol>] :path required
      # @option opts [ResourceRegistry::Meta] :meta optional
      # @return [Dry::Monads::Result::Success] if params pass validation
      # @return [Dry::Monads::Result::Failure] if params fail validation
      params do
        required(:path).array(:symbol)
        optional(:meta).maybe(:hash)
      end
    end
  end
end