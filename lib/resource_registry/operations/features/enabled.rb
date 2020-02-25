# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features

      # Check if a Feature is enabled
      # @param [Symbol] name Name of the feature
      # @param [Hash] options Options passed through to feature enabled check
      # @return [true] if the feature is enabled
      # @return [false] if the feature is disabled
      class Enabled
        send(:include, Dry::Monads[:result, :do])

        def call(name:, options: {})
          feature(name).enabled(args)
        end
        
      end
    end
  end
end