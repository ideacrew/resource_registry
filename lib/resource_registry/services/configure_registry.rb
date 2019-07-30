module ResourceRegistry
  module Services
    class ConfigureRegistry

      include Dry::Transaction(container: Registry)

      step :load_source,     with: 'resource_registry.operations.load'
      step :parse,           with: 'resource_registry.operations.parse'
      step :load_application_initializer, with: 'resource_registry.transactions.registry'
      step :load_application_options_namespace

      private

      def load_application_initializer(input, preferences: {})
        preferences.deep_stringify_keys!

        super input.merge(preferences)
      end

      def load_application_options_namespace(input)

        return Success(input)
      end    
    end
  end
end