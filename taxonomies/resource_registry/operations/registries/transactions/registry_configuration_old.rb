# frozen_string_literal: true

module ResourceRegistry
  module Registries
    module Transactions
      class RegistryConfiguration
        send(:include, Dry::Transaction(container: Registry))

        step :validate, with: 'resource_registry.registries.validate'

      end
    end
  end
end
