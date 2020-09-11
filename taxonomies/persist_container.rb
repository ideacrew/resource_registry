# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Operations
      class PersistContainer

        include Dry::Transaction::Operation

        def call(input)
          Registry.merge(input)

          Success(input)
        end
      end
    end
  end
end
