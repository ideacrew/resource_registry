# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Container
      # Add key/value pair attributes to a Dry::Container instance
      class Write
        send(:include, Dry::Monads[:result, :do])

        # @param [Dry::Container] container
        # @param [Array<ResourceRegistry::Entities::Key>] keys
        # @return [Dry::Monads::Result<Dry::Container>] Container populated with key values wrapped in Dry::Monads::Result
        def call(container, keys)
          container = yield write(container, keys)
          Success(container)
        end

        private

        def find_or_create_namespace(namespace); end

        def write(container, keys); end

      end
    end
  end
end
