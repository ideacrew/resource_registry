# frozen_string_literal: true

module ResourceRegistry
  module Registries
    module Transactions
      class Create

        include Dry::Transaction(container: ::Registry)

        # step :start_registry_services
        step :load_application_configuration, with: 'resource_registry.registries.load_application_configuration'
        step :load_application_dependencies,  with: 'resource_registry.registries.load_application_dependencies'
        # step :load_override_settings
        # step :start_application_services
        step :finalize_registry

        private

        def start_registry_services(input)
          Success(input)
        end

        def load_override_settings(input)
          Success(input)
        end

        def start_application_services(input)
          Success(input)
        end

        def finalize_registry(input)
          Registry.finalize!(freeze: true)

          Success(true)
        end
      end
    end
  end
end