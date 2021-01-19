# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Mongoid
      # Instantiate a new Dry::Container object
      class Find
        send(:include, Dry::Monads[:result, :do])

        # @param [String] key unique feature key
        # @return [Dry::Container] A non-finalized Dry::Container with associated configuration values wrapped in Dry::Monads::Result
        def call(key)
          feature = yield find(key)
          
          Success(feature)
        end

        private

        def find(key)
          feature = ResourceRegistry::Mongoid::Feature.where(key: key).first
          
          Success(feature)
        end
      end
    end
  end
end

