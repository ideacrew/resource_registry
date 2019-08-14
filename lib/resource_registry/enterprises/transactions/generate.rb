module ResourceRegistry
  module Enterprises
    module Transactions
      class Generate
        
        include Dry::Transaction(container: ::Registry)

        step :validate,  with: 'resource_registry.enterprises.validate'
        step :create,    with: 'resource_registry.enterprises.create'

        private

        # FIX ME: Unable to validate against the Option Schema
        def validate(input)
          input.deep_symbolize_keys!
          result = super(input[:enterprise])          
          
          if result.success?
            Success(result)
          else
            Failure(result)
          end
        end
      end
    end
  end
end