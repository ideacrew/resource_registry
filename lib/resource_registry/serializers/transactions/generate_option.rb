module ResourceRegistry
  module Serializers
    module Transactions
      class GenerateOption
        
        include Dry::Transaction(container: ResourceRegistry::Registry)

        step :validate, with: 'resource_registry.operations.validate_option'
        step :create_option, with: 'resource_registry.operations.create_option'

        private

        # FIX ME: Unable to validate against the Option Schema
        def validate(input)
          return Success(input)
        end
      end
    end
  end
end