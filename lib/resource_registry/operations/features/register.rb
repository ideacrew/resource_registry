# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features

      # Add a Feature
      # @param [Symbol] name Name of feature to register
      # @param [Object] item Feature code (proc) or reference to code to invoke
      # @param [Hash] options whether the item should be called when feature is registered 

      # @return result of the feature instance register call
      class Register
        send(:include, Dry::Monads[:result, :do])

        def call(name:, item:, options: {})
          feature(name).register(item, options)
        end
        
      end
    end
  end
end