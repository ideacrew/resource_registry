# frozen_string_literal: true

module ResourceRegistry
  module Subscriptions
    class Subscribe

      attr_reader :validator, :repository

      def initialize(validator:, repository:)
        @validator = validator
        @repository = repository
      end

      def call(params)
        return repository.register(params) if validator.validate(params)
        nil
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
