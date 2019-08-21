# frozen_string_literal: true

module ResourceRegistry
  module Enterprises
    module Operations
      class Create

        include Dry::Transaction::Operation

        def call(input)
          entity = ResourceRegistry::Entities::Enterprise.new(input.to_h)
          return Success(entity)
        end
      end
    end
  end
end