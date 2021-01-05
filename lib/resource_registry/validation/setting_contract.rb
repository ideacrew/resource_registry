# frozen_string_literal: true

module ResourceRegistry
  module Validation
    # Schema and validation rules for the {ResourceRegistry::Setting} domain model
    class SettingContract < ResourceRegistry::Validation::ApplicationContract

      # @!method call(opts)
      # @param [Hash] opts the parameters to validate using this contract
      # @option opts [Symbol] :key required
      # @option opts [Any] :item optional
      # @option opts [Hash] :options optional
      # @option opts [ResourceRegistry::Meta] :meta optional
      # @return [Dry::Monads::Result::Success] if params pass validation
      # @return [Dry::Monads::Result::Failure] if params fail validation
      params do
        required(:key).value(:symbol)
        required(:item).filled(:any)
        optional(:options).maybe(:hash)
        optional(:meta).maybe(:hash)

        before(:value_coercer) do |setting|
          item = if setting[:meta] && setting[:meta][:content_type] == :duration
            Types::Duration[setting[:item]]
          elsif setting[:item].is_a? String
            dates = setting[:item].scan(/(\d{4}\-\d{2}\-\d{2})\.\.(\d{4}\-\d{2}\-\d{2})/).flatten
            if dates.present?
              dates = dates.collect{|str| Date.strptime(str, "%Y-%m-%d") }
              Range.new(*dates)
            end
          end

          setting.to_h.merge(item: item) if item
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
