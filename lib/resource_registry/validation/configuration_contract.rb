# frozen_string_literal: true

module ResourceRegistry
  module Validation

    # Schema and validation rules for the {ResourceRegistry::Configuration} domain model
    class ConfigurationContract < ResourceRegistry::Validation::ApplicationContract

      # @!method call(params)
      # @param [Symbol] name required
      # @param [String, Pathname] root required
      # @param [DateTime] created_at optional
      # @param [Bool] register_meta optional
      # @param [String] system_dir optional
      # @param [String] default_namespace optional
      # @param [String] auto_register optional
      # @param [Array<String>] load_path optional
      # @param [Array<ResourceRegistry::Setting>] :settings optional
      # @return [Dry::Monads::Result::Success] if params pass validation
      # @return [Dry::Monads::Result::Failure] if params fail validation
      params do
        required(:name).value(:symbol)
        required(:root).value(:any)
        optional(:created_at).maybe(:date_time)
        optional(:register_meta).maybe(:bool)

        optional(:system_dir).maybe(:string)
        optional(:default_namespace).maybe(:string)
        optional(:auto_register).array(:string)
        optional(:load_path).maybe(:string)
        optional(:settings).array(:hash)

        # @!method before(value_coercer)
        # Coerce root String values to Pathname type
        before(:value_coercer) do |result|
          result.to_h.merge({ root: Pathname.new(result[:root]) }) if result[:root].is_a? String
        end
      end

      # rubocop:disable Style/RescueModifier
      # Verifies the Pathname exists
      # @!method rule(root)
      rule(:root) do
        return unless key? && value
        value.realpath rescue key.failure("pathname not found: #{value}")
      end
      # rubocop:enable Style/RescueModifier

    end
  end
end
