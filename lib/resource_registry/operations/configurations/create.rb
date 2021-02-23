# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Configurations
      # Create a Configuration
      class Create
        send(:include, Dry::Monads[:result, :do])

        def self.call(params)
          new.call(params)
        end

        def call(params)
          configuration_values = yield validate(params)
          configuration        = yield create(configuration_values)

          Success(configuration)
        end

        private

        def validate(params)
          result = ResourceRegistry::Validation::ConfigurationContract.new.call(params)

          if result.success?
            Success(result.to_h)
          else
            Failure(result)
          end
        end

        def create(configuration_values)
          configuration = ResourceRegistry::Configuration.new(configuration_values)

          Success(configuration)
        end
      end
    end
  end
end
