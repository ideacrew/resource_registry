require 'dry/system/container'

module ResourceRegistry
  module Registries
    class Registry

      include Dry::Transaction(container: ::Registry)

      step :validate_application_config, with: 'resource_registry.operations.validate_registry'
      step :load_application_config
      # step :set_application_load_paths
      step :validate_resource_registry_config, with: 'resource_registry.operations.validate_registry'
      step :load_resource_registry_config
      step :set_resource_registry_load_paths

      private

      def validate_application_config(input)
        application_attrs  = transform_root_to_path(input['application'])
        result = super(application_attrs)

        if result.success?
          Success(input)
        else
          Failure(result)
        end
      end

      def load_application_config(input)
        container.configure do |config|
          input['application']['config'].each_pair do |key, value|
            config.send "#{key}=", value
          end
        end

        Success(input)
      end

      def set_application_load_paths(input)
        Success(input)
      end

      def validate_resource_registry_config(input)
        registry_attrs  = transform_root_to_path(input['resource_registry'])
        result = super(registry_attrs)

        if result.success?
          Success(input)
        else
          Failure(result)
        end
      end

      def load_resource_registry_config(input)
        input['resource_registry']['config'].each_pair do |key, value|
          container.register("resource_registry.config.#{key}", value)
        end

        Success(input)
      end

      def set_resource_registry_load_paths(input)
        container.register("resource_registry.load_paths", input['resource_registry']['load_paths'])

        Success(input)
      end

      def container
        ::Registry
      end

      def transform_root_to_path(params)
        params['config']['root'] = Pathname.new(params['config']['root']) if params['config'].keys.include?('root')
        params
      end
    end
  end
end