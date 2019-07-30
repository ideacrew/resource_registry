module ResourceRegistry
  module Serializers
    module Transactions
      class TransformOption
        
        include Dry::Transaction(container: ResourceRegistry::Registry)

        step :validate, with: 'resource_registry.operations.validate_option'
        step :generate_option, with: 'resource_registry.operations.generate_option'

        private

        # FIX ME: Unable to validate against the Option Schema
        def validate(input)
          return Success(input)
        end
      end
    end
  end
end