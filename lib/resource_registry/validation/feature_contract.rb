# frozen_string_literal: true

module ResourceRegistry
  module Validation
    # Schema and validation rules for the {ResourceRegistry::Feature} domain model
    class FeatureContract < ResourceRegistry::Validation::ApplicationContract

      # @!method call(opts)
      # @param [Hash] opts the parameters to validate using this contract
      # @option opts [Symbol] :key required
      # @option opts [Bool] :is_enabled required
      # @option opts [Array<Symbol>] :namespace optional
      # @option opts [Any] :item optional
      # @option opts [Hash] :options optional
      # @option opts [ResourceRegistry::Meta] :meta optional
      # @option opts [Array<ResourceRegistry::Setting>] :settings optional
      # @return [Dry::Monads::Result::Success] if params pass validation
      # @return [Dry::Monads::Result::Failure] if params fail validation
      params do
        required(:key).value(:symbol)
        required(:namespace_path).value(:hash)
        required(:is_enabled).value(:bool)
        optional(:item).value(:any)
        optional(:options).maybe(:hash)
        optional(:meta).maybe(:hash)
        optional(:settings).array(:hash)

        before(:value_coercer) do |result|
          settings = result[:settings]&.map(&:deep_symbolize_keys)&.collect do |setting|
            setting.tap do |setting|
              if setting[:meta] && setting[:meta][:content_type] == :duration
                setting[:item] = Types::Duration[setting[:item]]
              elsif setting[:item].is_a? String
                dates = setting[:item].scan(/(\d{4}\-\d{2}\-\d{2})\.\.(\d{4}\-\d{2}\-\d{2})/).flatten
                if dates.present?
                  dates = dates.collect{|str| Date.strptime(str, "%Y-%m-%d") }
                  setting[:item] = Range.new(*dates)
                end
              end
            end
          end
          result[:namespace_path][:path] = result[:namespace_path][:path].map(&:to_sym) if result[:namespace_path] && result[:namespace_path][:path]
          result.to_h.merge(
                             key: result[:key]&.to_sym,
                             meta: result[:meta]&.symbolize_keys,
                             namespace_path: result[:namespace_path]&.deep_symbolize_keys,
                             settings: settings || []
                           )
        end
      end

      # @!macro [attach] rulemacro
      #   Validates a nested hash of $1 params
      #   @!method $0($1)
      #   @param [Symbol] $1 key
      #   @return [Dry::Monads::Result::Success] if nested $1 params pass validation
      #   @return [Dry::Monads::Result::Failure] if nested $1 params fail validation
      rule(:namespace_path) do
        if key? && value
          result = ResourceRegistry::Validation::NamespacePathContract.new.call(value)

          # Use dry-validation error form to pass error hash along with text to calling service
          # self.result.to_h.merge!({meta: result.to_h})
          key.failure(text: "invalid meta", error: result.errors.to_h) if result && result.failure?
        end
      end
    end
  end
end
