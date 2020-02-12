# frozen_string_literal: true

module ResourceRegistry
  module Validation
    module Features

      # Schema and validation rules for {ResourceRegistry::Entities::Feature}
      class FeatureContract < ResourceRegistry::Validation::ApplicationContract

        # @!method call(params)
        # @param params [Hash] options used to create the contract
        #   @options params [Symbol] :key (optional)
        #   @options params [Symbol] :parent_key (optional)
        #   @options params [Bool] :is_required (optional)
        #   @options params [Bool] :is_enabled (optional)
        #   @options params [ResourceRegistry::Entities::::Option] :options (optional)
        #   @return [Dry::Monads::Result::Success, Dry::Monads::Result::Failure]
        params do
          required(:key).value(:symbol)
          optional(:parent_key).maybe(:symbol)
          required(:is_required).value(:bool)
          required(:is_enabled).value(:bool)
          # required(:ui_metadata).value(ResourceRegistry::UiMetadata::Validation::UiMetadataContract)
          optional(:ui_metadata).maybe(:hash)
          # optional(:options).array(ResourceRegistry::Options::Validation::OptionContract)
          optional(:options).array(:hash)
          optional(:features).array(:hash)
        end

      end
    end
  end
end
