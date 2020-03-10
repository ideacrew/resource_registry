# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Registries

      # Create a Feature
      class Configure
        send(:include, Dry::Monads[:result, :do])

        def call(registry, config_params)
          config_values   = yield validate(config_params)
          configuration   = yield create(config_values)
          registry        = yield register(registry, configuration)
          
          Success(registry)
        end

        private

        def validate(config_params)
          result = ResourceRegistry::Validation::ConfigurationContract.new.call(config_params)

          if result.success?
            Success(result.to_h)
          else
            Failure("invalid configuration passed")
          end
        end

        def create(config_values)
          configuration = ResourceRegistry::Configuration.new(config_values)

          Success(configuration)
        end

        def register(registry, configuration)
          registry.register_configuration(configuration.to_h)

          Success(registry)
        end
      end
    end
  end
end