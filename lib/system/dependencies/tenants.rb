# frozen_string_literal: true

Registry.namespace :"resource_registry.tenants" do

  register :validate do
    ResourceRegistry::Tenants::Validation::TenantContract.new
  end
end