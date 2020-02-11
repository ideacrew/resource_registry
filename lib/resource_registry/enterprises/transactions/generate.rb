# frozen_string_literal: true

module ResourceRegistry
  module Enterprises
    module Transactions
      class Generate
        send(:include, Dry::Transaction(container: ::Registry))

        step :symbolize_keys, with: 'resource_registry.serializers.symbolize_keys'
        step :validate,       with: 'resource_registry.enterprises.validate'
        step :create,         with: 'resource_registry.enterprises.create'

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

        def create(input)
          if Registry['resource_registry.load_application_settings']
            super(input)
          else
            Success(input)
          end
        end
      end
    end
  end
end