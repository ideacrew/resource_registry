ResourceRegistry::Registry.namespace "resource_registry.operations" do |container|

  container.register 'load' do
    ResourceRegistry::Stores::Operations::LoadFile.new
  end
  
  # This is an operation type
  container.register 'parse' do
    ResourceRegistry::Serializers::Operations::ParseYaml.new
  end
              
  # This is a transaction type
  # Transactions have many operations
  container.register 'transform' do
    ResourceRegistry::Serialzers::GenerateOptions.new
  end
              
  container.register 'persist' do
    ResourceRegistry::Stores::Operations::PersistContainer.new
  end

end
