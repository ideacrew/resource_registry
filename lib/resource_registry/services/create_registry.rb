module ResourceRegistry
  module Services

    class Container
      extend Dry::Container::Mixin

      namespace :transactions do
        register :registry do
          ResourceRegistry::Registries::Registry.new
        end

        register :create do
          Users::Create.new
        end
      end
 
      namespace :operations do
        register :load_file do
          ResourceRegistry::Stores::LoadFile.new
        end

        register :parse_yaml do
          ResourceRegistry::Serializers::ParseYaml.new
        end

        register :validate_registry do
          ResourceRegistry::Registries::Validation::RegistryContract.new
          # ResourceRegistry::Registries::RegistryValidator.new
        end
      end
    end

    class CreateRegistry
      include Dry::Transaction(container: Container)

      step :read,  with: 'operations.load_file'
      step :parse, with: 'operations.parse_yaml'
      step :create_registry, with: 'transactions.registry'
      step :create_gem_config
      step :create_persistence

      private

      def create_gem_config(input)
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