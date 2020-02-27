# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Registry
      class Merge
        send(:include, Dry::Monads[:result, :do])

        def call(params)
          Registry.merge(params.to_h)

          Success(Registry)
        end
      end
    end
  end
end