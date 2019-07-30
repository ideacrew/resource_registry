module ResourceRegistry
  module Services

    class CreateRegistry
      include Dry::Transaction(container: ResourceRegistry::Registry)

      step :load_source,     with: 'resource_registry.operations.load'
      step :parse,           with: 'resource_registry.operations.parse'
      step :create_registry, with: 'resource_registry.transactions.registry'
      step :create_resource_registry
      step :create_persistence

      private

      def create_registry(input, preferences: {})
        preferences.deep_stringify_keys!
        super input.merge(preferences)
      end

      def create_resource_registry(input, preferences: {})
        preferences[:resource_registry][:config].each_pair do |key, value|
          input.register("resource_registry.config.#{key}", value)
        end

        input.register("resource_registry.load_paths", preferences[:resource_registry][:load_paths])
        return Success(input)
      end

      def create_persistence(input)
        return Success(input)
      end


      # def execute
      #   result = validate(get_config_params)

      #   if result.success?
      #     container = ResourceRegistry::Registries::Registry.call(result: result)
      #     ResourceRegistry.const_set("Registry", container)
      #     create_persistence
      #   else
      #     raise Error::InvalidContractParams, "Registry error(s): #{result.errors(full: true).to_h}"
      #   end
      # end

      # private

      # def validate(config_params)
      #   registry_contract = ResourceRegistry::Registries::Validation::RegistryContract.new
      #   registry_contract.call(config_params)
      # end

      # def file_path
      #   ResourceRegistry.system_path.join("config", "public_options.yml")
      # end

      # def content
      #   ResourceRegistry::Stores::FileStore.call(content: file_path, action: :load)
      # end

      # def params
      #   ResourceRegistry::Serializers::YamlSerializer.call(content: content, action: :parse)
      # end

      # def params_with_preferences
      #   params.merge!(@app_params.except('options'))
      # end

      # def get_config_params
      #   config_params = params_with_preferences['registry']
      #   config_params['config']['root'] = Pathname.new(config_params['config']['root']) if config_params['config'].keys.include?('root')
      #   config_params
      # end

      # def create_persistence
      #   if persistence_options = @app_params['options']
      #     options_struct = ResourceRegistry::Serializers::OptionsSerializer.call(content: persistence_options, action: :generate)
      #     container = ResourceRegistry::Serializers::ContainerSerializer.call(content: options_struct, action: :generate)
      #     ResourceRegistry.const_get("Registry").merge(container)
      #   end
      # end
    end
  end
end