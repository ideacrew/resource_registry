module ResourceRegistry
  module Registries
    module Transactions
      class RegistryConfiguration

        include Dry::Transaction(container: ::Registry)

        step :validate, with: 'resource_registry.registries.validate'

        private

        def validate(input)
          result = super
          return Success(result)
        end

        # def load_application_initializer(input, preferences: {})
        #   preferences.deep_stringify_keys!
          
        #   super input.merge(preferences)
        # end

        # def load_application_options_namespace(input)

        #   return Success(input)
        # end    
      end
    end
  end
end