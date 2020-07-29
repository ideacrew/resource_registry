# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      # Disable a Feature
      # @param [Symbol] name Name of feature to disable
      # @param [Hash] options Options passed through to feature disable call
      # @return result of the feature instance disable call
      class Disable
        send(:include, Dry::Monads[:result, :do])

        def call(name:, options: {})
          feature(name).disable(args)
        end

      end
    end
  end
end
