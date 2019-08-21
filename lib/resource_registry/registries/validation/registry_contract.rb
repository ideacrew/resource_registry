# frozen_string_literal: true

require 'resource_registry/options/validation/option_contract'

module ResourceRegistry
  module Registries
    module Validation
      RegistryContract = ResourceRegistry::Validation::ApplicationContract.build do
        params do
          required(:config).hash do
            required(:name).filled(:string)
            required(:root).filled(type?: Pathname)

            optional(:default_namespace).filled(:string)
            optional(:system_dir).filled(:string)
            optional(:load_path).filled(:string)
            optional(:auto_register).array(:string)
          end

          # required(:app_name).filled(:string)
          optional(:load_paths).array(:string)
          optional(:timestamp).value(:string)
          optional(:env).value(Types::Environment)

          optional(:options).filled(type?: ResourceRegistry::Options::Validation::OptionContract)
          # optional(:options).filled(:OptionContract) # use this form for Registry resolver
        end

        # Path name must exist
        # rubocop:disable Style/RescueModifier
        rule([:config, :root]) do
          Pathname(value).realpath rescue key.failure("pathname not found: #{value}")
        end
        # rubocop:enable Style/RescueModifier

      end
    end
  end
end