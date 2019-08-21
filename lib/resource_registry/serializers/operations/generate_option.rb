# frozen_string_literal: true

module ResourceRegistry
  module Serializers
    module Operations
      class GenerateOption

        include Dry::Transaction::Operation

        def call(input)
          option = ResourceRegistry::Entities::Option.new(input)
          return Success(option)
        end
      end
    end
  end
end