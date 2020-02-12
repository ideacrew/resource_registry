# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Container

      class Read
        send(:include, Dry::Monads[:result, :do])

        def call(params = {})
        end

      end
    end
  end
end