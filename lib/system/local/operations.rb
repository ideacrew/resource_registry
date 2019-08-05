ResourceRegistry::Container.namespace "resource_registry.operations" do |container|

  container.register 'load' do
    container.resolve('load_file')
  end

  container.register 'load_file' do
    ResourceRegistry::Stores::Operations::LoadFile.new
  end

  container.register 'persist' do
    container.resolve('persist_container')
  end

  container.register 'persist_container' do
    ResourceRegistry::Stores::Operations::PersistContainer.new
  end
  
  container.register 'parse' do
    container.resolve('parse_yaml')
  end

  container.register 'parse_yaml' do 
    ResourceRegistry::Serializers::Operations::ParseYaml.new
  end
 
  container.register 'generate_option' do 
    ResourceRegistry::Serializers::Operations::GenerateOption.new
  end

  container.register 'generate_container' do 
    ResourceRegistry::Serializers::Operations::GenerateContainer.new
  end

  container.register 'validate_registry' do
    ResourceRegistry::Registries::Validation::RegistryContract.new
  end

  container.register 'validate_option' do
    ResourceRegistry::Options::Validation::OptionContract
    # ResourceRegistry::Registries::Validation::RegistryContract.new
  end
end