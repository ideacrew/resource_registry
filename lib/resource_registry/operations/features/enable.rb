# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      # Enable a Feature
      # @param [Symbol] name Name of feature to enable
      # @param [Hash] options Options passed through to feature enable call
      # @return result of the feature instance enable call
      class Enable
        send(:include, Dry::Monads[:result, :do])

        def call(name:, _options: {})
          feature(name).enable(args)
        end

      end
    end
  end
end
