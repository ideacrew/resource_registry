module ResourceRegistry
  module Serializers
    module Transactions
      class TransformOption
        
        include Dry::Transaction(container: Registry)

        step :validate, with: 'resource_registry.operations.validate_option'
        step :generate_option, with: 'resource_registry.operations.generate_option'

        private

        # FIX ME: Unable to validate against the Option Schema
        def validate(input)
          input.deep_symbolize_keys!
          result = super(input)
          
          if result.success?
            Success(result.to_h)
          else
            Failure(result)
          end
        end
      end
    end
  end
end