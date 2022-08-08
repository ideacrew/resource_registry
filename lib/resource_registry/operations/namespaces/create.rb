# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Namespaces
      # Create a Namespace
      class Create
        send(:include, Dry::Monads[:result, :do])

        def call(params)
          values = yield validate(params)
          namespace = yield create(values)

          Success(namespace)
        end

        private

        def validate(params)
          ResourceRegistry::Validation::NamespaceContract.new.call(params)
        end

        def create(values)
          namespace = ResourceRegistry::Namespace.new(values.to_h)

          Success(namespace)
        end
      end
    end
  end
end
