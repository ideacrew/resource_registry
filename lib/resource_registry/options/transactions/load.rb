# frozen_string_literal: true

module ResourceRegistry
  module Options
    module Transactions
      class Load

        include Dry::Transaction(container: Registry)

        step :load_source,         with: 'resource_registry.stores.load_file'
        step :parse,               with: 'resource_registry.serializers.parse_yaml'
        step :validate,            with: 'resource_registry.options.validate'
        # step :transform_option,    with: 'resource_registry.transactions.transform_option'

        private

        def validate(input)
          input.deep_symbolize_keys!
          result = super

          if result.success?
            Success(result.to_h)
          else
            Failure(result.errors)
          end
        end
      end
    end
  end
end