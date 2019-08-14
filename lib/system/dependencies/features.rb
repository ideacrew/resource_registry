Registry.namespace :"resource_registry.features" do

  register :validate do
    ResourceRegistry::Features::Validation::FeatureContract
  end
end