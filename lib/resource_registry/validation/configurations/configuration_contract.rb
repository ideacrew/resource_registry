# frozen_string_literal: true

module ResourceRegistry
  module Validation
    module Configurations

      # Schema and validation rules for {ResourceRegistry::Entities::Registry}
      class ConfigurationContract < ResourceRegistry::Validation::ApplicationContract

        # @!method call(params)
        # @param params [Hash] options used to create the contract
        #   @options params[Symbol] :name (required)
        #   @options params[String] :root (required)
        #   @options params[DateTime] :created_at (optional)
        #   @options params[Boolean] :register_meta(optional)
        #   @options params[String] :system_dir (optional)
        #   @options params[String] :default_namespace (optional)
        #   @options params[String] :auto_register (optional)
        #   @options params[Array<String>] :load_path (optional)
        #   @options params[Array<ResourceRegistry::Entities::Setting>] :settings (optional)
        #   @return [Dry::Monads::Result::Success, Dry::Monads::Result::Failure]
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

          before(:value_coercer) do |result|
            result.to_h.merge({ root: Pathname.new(result[:root]) }) if result[:root].is_a? String
          end
        end

        # Path name must exist
        # @!method rule(:root)
        # rubocop:disable Style/RescueModifier
        rule(:root) do
          return unless key? && value
          value.realpath rescue key.failure("pathname not found: #{value}")
        end
        # rubocop:enable Style/RescueModifier

      end
    end
  end
end
