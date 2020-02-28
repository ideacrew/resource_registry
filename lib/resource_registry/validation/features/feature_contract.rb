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
        #   @options params [Any] :item (optional)
        #   @options params [Hash] :options (optional)
        #   @options params [ResourceRegistry::Entities::Meta] :meta (optional)
        #   @options params [Array<ResourceRegistry::Entities::Setting>] :meta (optional)
        #   @return [Dry::Monads::Result::Success, Dry::Monads::Result::Failure]
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
              meta: result[:meta]&.symbolize_keys,
              settings: (result[:settings]&.map(&:deep_symbolize_keys) || []),
              namespace: result[:namespace]&.map(&:to_sym)
            })
          end
        end

        rule(:meta) do
          if key? && value
            result = ResourceRegistry::Validation::Metas::MetaContract.new.call(value)
            # Use dry-validation metadata error form to pass error hash along with text to calling service
            key.failure(text: "invalid meta", error: result.errors.to_h) if result.failure?
            self.result.to_h.merge!({meta: result.to_h})
          end
        end

        rule(:settings).each do
          if key? && value
            result = ResourceRegistry::Validation::Settings::SettingContract.new.call(value)           
            # Use dry-validation metadata error form to pass error hash along with text to calling service
            key.failure(text: "invalid settings", error: result.errors.to_h) if result.failure?
          end
        end
      end
    end
  end
end
