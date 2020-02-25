# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features

      # Is the feature registered?
      # @param [Symbol] name Name of feature

      # @return [true] if the features is registered
      # @return [flase] if the features is not registered
      class Exist
        send(:include, Dry::Monads[:result, :do])

        def call(name:)
          feature(name).exist
        end

      end
    end
  end
end