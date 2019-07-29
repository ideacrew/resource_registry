module ResourceRegistry
  module Services
    class CreateRegistry
      include ResourceRegistry::Services::Service

      def call(**params)
        @type = params[:type]
        @preferences = params[:preferences] || {}
        @preferences.deep_stringify_keys!
        execute
      end

      def execute
        result = validate(get_config_params)

        if result.success?
          container = ResourceRegistry::Registries::Registry.call(result: result)
          ResourceRegistry.const_set("#{@type.to_s.capitalize}Registry", container)
          create_persistence
        else
          raise Error::InvalidContractParams, "#{@type.to_s.capitalize}Registry error(s): #{result.errors(full: true).to_h}"
        end
      end

      private

      def validate(config_params)
        registry_contract = ResourceRegistry::Registries::Validation::RegistryContract.new
        registry_contract.call(config_params)
      end

      def file_path
        ResourceRegistry.system_path.join("config", "#{@type}_options.yml")
      end

      def content
        ResourceRegistry::Stores::FileStore.call(content: file_path, action: :load)
      end

      def params
        ResourceRegistry::Serializers::YamlSerializer.call(content: content, action: :parse)
      end

      def params_with_preferences
        params.merge!(@preferences)
      end

      def get_config_params
        config_params = params_with_preferences['registry']
        config_params['config']['root'] = Pathname.new(config_params['config']['root']) if config_params['config'].keys.include?('root')
        config_params
      end

      def create_persistence
        if persistence_options = @preferences['options']
          options_struct = ResourceRegistry::Serializers::OptionsSerializer.call(content: persistence_options, action: :generate)
          container = ResourceRegistry::Serializers::ContainerSerializer.call(content: options_struct, action: :generate)
          ResourceRegistry.const_get("#{@type.to_s.capitalize}Registry").merge(container)
        end
      end
    end
  end
end