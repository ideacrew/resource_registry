require 'dry/system/container'

module ResourceRegistry
  module Registries
    class Registry

      include Dry::Transaction(container: ResourceRegistry::Registry)

      step :validate, with: 'resource_registry.operations.validate_registry'#, catch: StandardError
      step :build_container
      step :load_config
      step :set_load_paths

      private

      def validate(input)
        input = transform_root_to_path(input['application'])
        result = super(input)

        if result.success?
          return Success(result)
        else
          return Failure(result)
        end
      end

      def build_container(input)
        init_container
        return Success(input)
      end

      def load_config(input)
        @container.configure do |config|
          input[:config].each_pair do |key, value|
            config.send "#{key}=", value
          end
        end
        return Success(input)
      end

      def set_load_paths(input)
        # @container.send :load_paths!, @params[:load_paths]
        return Success(@container)
      end

      def init_container
        return @container if defined? @container
        @container = Dry::System::Container
      end

      def transform_root_to_path(params)
        params['config']['root'] = Pathname.new(params['config']['root']) if params['config'].keys.include?('root')
        params
      end
    end
  end
end