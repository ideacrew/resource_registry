ResourceRegistry::Registry.namespace "resource_registry.operations" do |container|

  container.register 'load' do
    container.resolve('load_file')
  end

  container.register 'load_file' do
    ResourceRegistry::Stores::LoadFile.new
  end
  
  # This is an operation type
  container.register 'parse' do
    container.resolve('parse_yaml')
  end

  container.register 'parse_yaml' do 
    ResourceRegistry::Serializers::Operations::ParseYaml.new
  end
              
  # This is a transaction type
  # Transactions have many operations
  container.register 'transform' do
    ResourceRegistry::Serialzers::GenerateOptions.new
  end
              
  container.register 'persist' do
    container.resolve('persist_container')
  end

  container.register 'persist_container' do
    ResourceRegistry::Stores::Operations::PersistContainer.new
  end

  container.register 'validate_registry' do
    ResourceRegistry::Registries::Validation::RegistryContract.new
  end
end