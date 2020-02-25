# frozen_string_literal: true

module ResourceRegistry
  module Validation
    module Features

      # Schema and validation rules for {ResourceRegistry::Entities::Feature}
      class FeatureContract < ResourceRegistry::Validation::ApplicationContract

        # @!method call(params)
        # @param params [Hash] options used to create the contract
        #   @options params [Symbol] :key (required)
        #   @options params [Array<Symbol>] :namespace (required)
        #   @options params [Bool] :is_enabled (required)
        #   @options params [ResourceRegistry::Entities::Meta] :meta (optional)
        #   @options params [Array<ResourceRegistry::Entities::Setting>] :meta (optional)
        #   @return [Dry::Monads::Result::Success, Dry::Monads::Result::Failure]
        params do
          required(:key).value(:symbol)
          required(:namespace).maybe(:array)
          required(:is_enabled).value(:bool)
          # required(:ui_metadata).value(ResourceRegistry::UiMetadata::Validation::UiMetadataContract)
          optional(:meta).maybe(:hash)
          # optional(:options).array(ResourceRegistry::Options::Validation::OptionContract)
          optional(:settings).array(:hash)

          before(:value_coercer) do |result|
            if result[:namespace] && result[:namespace].size > 0
              result.to_h.merge({namespace: result[:namespace].map(&:to_sym)})
            end
          end
          
        end

      end
    end
  end
end
