module ResourceRegistry
  module Services
    class CreateRegistry
      include ResourceRegistry::Services::Service

      def call(**params)
        @type = params[:type]
        @preferences = params[:preferences] || {}
        execute
      end

      private

      def execute
        file_path = ResourceRegistry.system_path.join("config", "#{@type}_options.yml")
        content   = ResourceRegistry::Stores::FileStore.call(content: file_path, action: :load)
        params    = ResourceRegistry::Serializers::YamlSerializer.call(content: content, action: :parse)

        @preferences.deep_stringify_keys!
        config_params = get_config_params(params.merge(@preferences))
        registry_contract = ResourceRegistry::Registries::Validation::RegistryContract.new
        result = registry_contract.call(config_params)

        if result.success?
          container = ResourceRegistry::Registries::Registry.call(result: result)
          ResourceRegistry.const_set("#{@type.to_s.capitalize}Registry", container)
        else
          raise Error::InvalidContractParams, "#{@type.to_s.capitalize}Registry error(s): #{result.errors(full: true).to_h}"
        end
      end

      def get_config_params(params)
        config_params = params['registry']
        config_params['config']['root'] = Pathname.new(config_params['config']['root']) if config_params['config'].keys.include?('root')
        config_params
      end
    end
  end
end