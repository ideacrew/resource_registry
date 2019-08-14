require 'resource_registry/enterprises'

Registry.namespace :"resource_registry.enterprises" do

  register :validate do
    ResourceRegistry::Enterprises::Validation::EnterpriseContract
  end

  register :create do
    ResourceRegistry::Enterprises::Operations::Create.new
  end

  register :generate do
    ResourceRegistry::Enterprises::Transactions::Generate.new
  end
end