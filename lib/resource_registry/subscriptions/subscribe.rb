module ResourceRegistry
  module Subscriptions
    class Subscribe

      attr_reader :validator, :repository

      def initialize(validator:, repository:)
        @validator = validator
        @repository = repository
      end

      def call(params)
        if validator.validate(params)
          repository.register(params)
        else
          nil
        end
      end

      def self.build 
        new(
            validator: SubscriptionValidator.new,
            repository: repository
          )
      end

    end
  end
end
