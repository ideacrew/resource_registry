ResourceRegistry::Registry.namespace "resource_registry.transactions" do

  # Transactions have many Operations
  register 'transform' do
    ResourceRegistry::Serialzers::GenerateOptions.new
  end

  register 'registry' do
    ResourceRegistry::Registries::Registry.new
  end
end