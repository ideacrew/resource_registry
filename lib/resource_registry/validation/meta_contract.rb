# frozen_string_literal: true

module ResourceRegistry
  module Validation

    # Schema and validation rules for the {ResourceRegistry::Meta} domain model
    class MetaContract < ResourceRegistry::Validation::ApplicationContract

      # @!method call(params)
      # Validate a meta hash
      # @param [String] label required
      # @param [Symbol] type required
      # @param [Any] default required
      # @param [Any] value optional
      # @param [String] description optional
      # @param [Array<Any>] enum optional
      # @param [Bool] is_required optional
      # @param [Bool] is_visible optional
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
