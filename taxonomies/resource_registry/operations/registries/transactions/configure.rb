# frozen_string_literal: true

module ResourceRegistry
  module Registries
    module Transactions
      class Configure
        send(:include, Dry::Transaction(container: ::Registry))

        step :validate_application_configuration,       with: 'resource_registry.registries.validate'
        step :load_application_configuration
        # step :set_application_load_paths
        step :validate_resource_registry_configuration, with: 'resource_registry.registries.validate'
        step :load_resource_registry_configuration
        step :set_resource_registry_load_paths
        step :load_resolver_configuration
        step :set_custom_resolver

        private

        def validate_application_configuration(input)
          application_attrs = transform_root_to_path(input[:application])
          result = super(application_attrs)

          if result.success?
            Success(input)
          else
            Failure(result.errors)
          end
        end

        def load_application_configuration(input)
          container.configure do |config|
            input[:application][:config].each_pair do |key, value|
              config.send "#{key}=", value
            end
          end

          Success(input)
        end

        def validate_resource_registry_configuration(input)
          registry_attrs = transform_root_to_path(input[:resource_registry])
          result = super(registry_attrs)

          if result.success?
            Success(input)
          else
            Failure(result.errors)
          end
        end

        def load_resource_registry_configuration(input)
          input[:resource_registry][:config].each_pair do |key, value|
            container.register("resource_registry.config.#{key}", value)
          end

          # container.register("resource_registry.load_application_settings", input[:resource_registry][:load_application_settings])

          Success(input)
        end

        def set_resource_registry_load_paths(input)
          container.register("resource_registry.load_paths", input[:resource_registry][:load_paths])

          Success(input)
        end

        def load_resolver_configuration(input)
          input[:resource_registry][:resolver].each_pair do |key, value|
            container.register("resource_registry.resolver.#{key}", value)
          end

          Success(input)
        end

        def set_custom_resolver(input)
          container.configure do |config|
            config.resolver = ResourceRegistry::Serializers::OptionResolver.new
          end

          Success(input)
        end

        def container
          ::Registry
        end

        def transform_root_to_path(params)
          params[:config][:root] = Pathname.new(params[:config][:root]) if params[:config] && params[:config][:root] && !params[:config][:root].is_a?(Pathname)
          params
        end
      end
    end
  end
end
