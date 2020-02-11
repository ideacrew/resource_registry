# frozen_string_literal: true

module ResourceRegistry
  module UiMetadatas
    module Validation

      # Schema and validation rules for {ResourceRegistry::Entities::UiMetadata}
      class UiMetadataContract < ResourceRegistry::Validation::ApplicationContract


        # @!method call(params)
        # @param params [Hash] options used to create the contract
        #   @options params [String] :title (required)
        #   @options params [Symbol] :type (required)
        #   @options params [Any] :default (required)
        #   @options params [Any] :value (optional)
        #   @options params [String] :description (required)
        #   @options params [Array<Any>] :choices (optional)
        #   @options params [Bool] :is_required (optional)
        #   @options params [Bool] :is_visible (optional)
        #   @return [Dry::Monads::Result::Success, Dry::Monads::Result::Failure]
        params do
          required(:title).value(:string)
          required(:type).value(:symbol)
          required(:default).value(:any)
          optional(:value).maybe(:any)
          optional(:description).maybe(:string)
          optional(:choices).array(:hash)
          optional(:is_required).maybe(:bool)
          optional(:is_visible).maybe(:bool)
        end

      end
    end
  end
end
