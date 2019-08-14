require 'resource_registry/options'

Registry.namespace :"resource_registry.options" do

  register :validate do
    ResourceRegistry::Options::Validation::OptionContract
  end

  register :load do
    ResourceRegistry::Options::Transactions::Load.new
  end
end