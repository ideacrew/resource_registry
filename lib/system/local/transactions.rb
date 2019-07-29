ResourceRegistry::Registry.namespace "resource_registry.transactions" do |container|

  # Transactions have many Operations
  register 'transform' do
    ResourceRegistry::Serialzers::GenerateOptions.new
  end

end
