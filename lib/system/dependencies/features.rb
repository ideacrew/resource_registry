# frozen_string_literal: true

Registry.namespace :"resource_registry.features" do

  register :validate do
    ResourceRegistry::Features::Validation::FeatureContract.new
  end
end
