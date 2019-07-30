ResourceRegistry::Registry.namespace "resource_registry.transactions" do

  register 'transform' do
    ResourceRegistry::Serialzers::GenerateOptions.new
  end

  register 'registry' do
    ResourceRegistry::Registries::Registry.new
  end

  register 'generate_option' do
    ResourceRegistry::Serializers::Transactions::GenerateOption.new
  end
end