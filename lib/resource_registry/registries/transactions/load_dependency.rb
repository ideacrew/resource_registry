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

        private

        def create_container(input)
          if Registry['resource_registry.load_application_settings']
            super(input)
          else
            Success(input)
          end
        end

        def persist_container(input)
          if Registry['resource_registry.load_application_settings']
            super(input)
          else
            ResourceRegistry::Stores::Operations::HashStore.new.call(input)
          end
        end
      end
    end
  end
end

