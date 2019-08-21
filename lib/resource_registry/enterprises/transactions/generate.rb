# frozen_string_literal: true

module ResourceRegistry
  module Enterprises
    module Transactions
      class Generate

        include Dry::Transaction(container: ::Registry)

        step :symbolize_keys, with: 'resource_registry.serializers.symbolize_keys'
        step :validate,  with: 'resource_registry.enterprises.validate'
        step :create,    with: 'resource_registry.enterprises.create'

        private

        # FIX ME: Unable to validate against the Option Schema
        def validate(input)
          result = super(input[:enterprise])

          if result.success?
            Success(result)
          else
            Failure(result.errors)
          end
        end
      end
    end
  end
end