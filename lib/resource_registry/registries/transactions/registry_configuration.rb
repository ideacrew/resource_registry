# frozen_string_literal: true

module ResourceRegistry
  module Registries
    module Transactions
      class RegistryConfiguration

        include Dry::Transaction

        step :validate

        private

        def validate(input)
          result = ResourceRegistry::Registries::Validation::RegistryContract.call(input)
          return Success(result)
        end

        # def load_application_initializer(input, preferences: {})
        #   preferences.deep_stringify_keys!

        #   super input.merge(preferences)
        # end

        # def load_application_options_namespace(input)

        #   return Success(input)
        # end
      end
    end
  end
end