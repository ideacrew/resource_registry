ResourceRegistry::Container.namespace "resource_registry.transactions" do

  register 'transform' do
    ResourceRegistry::Serialzers::GenerateOptions.new
  end

  register 'registry' do
    ResourceRegistry::Registries::Registry.new
  end

  register 'transform_option' do
    ResourceRegistry::Serializers::Transactions::TransformOption.new
  end
end