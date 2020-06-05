# frozen_string_literal: true

module ResourceRegistry
  module Validation

    # Schema and validation rules for the {ResourceRegistry::Configuration} domain model
    class ConfigurationContract < ResourceRegistry::Validation::ApplicationContract

      # @!method call(opts)
      # @param [Hash] opts the parameters to validate using this contract
      # @option opts [Symbol] :name required
      # @option opts [String, Pathname] :root required
      # @option opts [DateTime] :created_at optional
      # @option opts [Bool] :register_meta optional
      # @option opts [String] :system_dir optional
      # @option opts [String] :default_namespace optional
      # @option opts [String] :auto_register optional
      # @option opts [Array<String>] :load_path optional
      # @option opts [Array<ResourceRegistry::Setting>] :settings optional
      # @return [Dry::Monads::Result::Success] if params pass validation
      # @return [Dry::Monads::Result::Failure] if params fail validation
      params do
        required(:name).value(:symbol)
        optional(:root).value(:any)
        required(:created_at).maybe(:date_time)
        optional(:register_meta).maybe(:bool)

        optional(:system_dir).maybe(:string)
        optional(:default_namespace).maybe(:string)
        optional(:auto_register).array(:string)
        optional(:load_path).maybe(:string)
        optional(:settings).array(:hash)

        # @!macro [attach] beforehook
        #   @!method $0($1)
        #   Coerce root String values to Pathname type
        before(:value_coercer) do |result|
          result.to_h.merge({ root: Pathname.new(result[:root]) }) if result[:root].is_a? String
        end
      end

      # rubocop:disable Style/RescueModifier
      
      # Verifies the Pathname exists
      rule(:root) do
        if key? && value
          value.realpath rescue key.failure("pathname not found: #{value}")
        end
      end
      # rubocop:enable Style/RescueModifier

    end
  end
end
