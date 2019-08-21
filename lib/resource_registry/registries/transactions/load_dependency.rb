# frozen_string_literal: true

module ResourceRegistry
  module Registries
    module Transactions
      class LoadDependency

        include Dry::Transaction(container: ::Registry)

        step :load_options,        with: 'resource_registry.options.load'
        step :parse_options,       with: 'resource_registry.serializers.parse_option'
        step :create_entity,       with: 'resource_registry.enterprises.generate'
        step :create_container,    with: 'resource_registry.serializers.generate_container'
        step :persist_container,   with: 'resource_registry.stores.persist_container'

      end
    end
  end
end

