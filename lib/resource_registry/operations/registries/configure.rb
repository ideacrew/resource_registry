# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Registries
      # Create a Feature
      class Configure
        send(:include, ::Dry::Monads[:result, :do])

        def call(registry, config_params)
          config_values   = yield validate(config_params)
          configuration   = yield create(config_values)
          registry        = yield register_configuration(registry, configuration)
          registry        = yield load_features(registry)

          Success(registry)
        end

        private

        def validate(config_params)
          result = ResourceRegistry::Validation::ConfigurationContract.new.call(config_params)

          if result.success?
            Success(result.to_h)
          else
            Failure("invalid configuration passed #{result.to_h[:errors]}")
          end
        end

        def create(config_values)
          configuration = ResourceRegistry::Configuration.new(config_values)

          Success(configuration)
        end

        def register_configuration(registry, configuration)
          registry.namespace(:configuration) do
            configuration.to_h.each do |attribute, value|
              register(attribute, value)
            end
          end

          Success(registry)
        end

        def load_features(registry)
          if load_path_given?(registry)
            result = ResourceRegistry::Operations::Registries::Load.new.call(registry: registry)
            result.success? ? Success(result.value!) : Failure(result.to_h[:errors])
          else
            Success(registry)
          end
        end

        def load_path_given?(registry)
          registry.key?('configuration.load_path')
        end
      end
    end
  end
end
