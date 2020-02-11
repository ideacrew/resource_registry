# frozen_string_literal: true

module ResourceRegistry
  module Registries
    module Validation

      # Schema and validation rules for {ResourceRegistry::Entities::Registry}
      class RegistryContract < ResourceRegistry::Validation::ApplicationContract

        # @!method call(params)
        # @param params [Hash] options used to create the contract
        #   @options params[Symbol] :name (required)
        #   @options params[String] :root (required)
        #   @options params[String] :default_namespace (optional)
        #   @options params[String] :system_dir (optional)
        #   @options params[Array<String>] :load_path (optional)
        #   @options params[String] :auto_register (optional)
        #   @options params[ResourceRegistry::Entities::::Option] :options (optional)
        #   @options params[String] :timestamp (optional)
        #   @see ResourceRegistry::Entities::Registry
        #   @return [Dry::Monads::Result::Success, Dry::Monads::Result::Failure]
        params do
          required(:name).value(:symbol)
          required(:root).value(type?: Pathname)
          optional(:default_namespace).maybe(:string)
          optional(:system_dir).maybe(:string)
          optional(:auto_register).array(:string)

          optional(:load_path).maybe(:string)

          optional(:load_paths).array(:string)
          optional(:timestamp).value(:string)
          optional(:options).array(:hash)
        end

        # Path name must exist
        # @!method rule(:root)
        # rubocop:disable Style/RescueModifier
        rule(:root) do
          Pathname(value).realpath rescue key.failure("pathname not found: #{value}")
        end
        # rubocop:enable Style/RescueModifier

      end
    end
  end
end
