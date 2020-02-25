# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features

      # Check if a Feature is disabled
      # @param [Symbol] name Name of the feature
      # @param [Hash] options Options passed through to feature disabled check
      # @return [true] if the feature is disabled
      # @return [false] if the feature is enabled
      class Disabled
        send(:include, Dry::Monads[:result, :do])

        def call(name:, options: {})
          feature(name).disabled(args)
        end
        
      end
    end
  end
end