module ResourceRegistry
  module Services
    class LoadRegistry

      include Dry::Transaction(container: ResourceRegistry::Registry)

      step :load_source,         with: 'resource_registry.operations.load'
      step :parse,               with: 'resource_registry.operations.parse'
      step :generate_option,     with: 'resource_registry.transactions.generate_option'
      step :generate_container,  with: 'resource_registry.operations.generate_container'
      step :persist_container,   with: 'resource_registry.operations.persist'

    end
  end
end