module ResourceRegistry
  module Registries
    module Transactions
      class LoadApplicationConfiguration

        include Dry::Transaction(container: ::Registry)

        step :load_source,        with: 'resource_registry.stores.load_file'
        step :parse,              with: 'resource_registry.serializers.parse_yaml'
        step :symbolize_keys,     with: 'resource_registry.serializers.symbolize_keys'
        step :configure_registry, with: 'resource_registry.registries.configure'
        # step :load_application_options_namespace

        private

        def configure_registry(input)
          input[:application].merge!(ResourceRegistry.config.to_h)
          super(input)
        end

        def load_application_options_namespace(input)
          return Success(input)
        end    
      end
    end
  end
end