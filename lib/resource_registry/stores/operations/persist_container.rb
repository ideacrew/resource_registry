module ResourceRegistry
  module Stores
    module Operations
      class PersistContainer

        include Dry::Transaction::Operation

        def call(input)
          ResourceRegistry::Registry.merge(input)
          return Success(input)
        end
      end
    end
  end
end