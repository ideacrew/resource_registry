Registry.namespace :"resource_registry.tenants" do

  register :validate do
    ResourceRegistry::Tenants::Validation::TenantContract
  end
end