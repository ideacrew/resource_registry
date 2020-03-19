# frozen_string_literal: true

module ResourceRegistry
  module Validation

    # Schema and validation rules for the {ResourceRegistry::Meta} domain model
    class MetaContract < ResourceRegistry::Validation::ApplicationContract

      # @!method call(opts)
      # @param [Hash] opts the parameters to validate using this contract
      # @option opts [String] :label required
      # @option opts [Symbol] :type required
      # @option opts [Any] :default required
      # @option opts [Any] :value optional
      # @option opts [String] :description optional
      # @option opts [Array<Any>] :enum optional
      # @option opts [Bool] :is_required optional
      # @option opts [Bool] :is_visible optional
      # @return [Dry::Monads::Result::Success] if params pass validation
      # @return [Dry::Monads::Result::Failure] if params fail validation
      params do
        required(:label).value(:string)
        required(:type).value(:symbol)
        required(:default).value(:any)
        optional(:value).maybe(:any)
        optional(:description).maybe(:string)
        optional(:enum).array(:hash)
        optional(:is_required).maybe(:bool)
        optional(:is_visible).maybe(:bool)
      end

    end
  end
end
