module ResourceRegistry
  module Services
    class LoadRegistryOptions

      include Dry::Transaction(container: Registry)

      step :load_source,         with: 'resource_registry.operations.load'
      step :parse,               with: 'resource_registry.operations.parse'
      step :transform_option,    with: 'resource_registry.transactions.transform_option'
      step :generate_container,  with: 'resource_registry.operations.generate_container'
      step :persist_container,   with: 'resource_registry.operations.persist'

    end
  end
end