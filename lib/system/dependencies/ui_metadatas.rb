# frozen_string_literal: true

Registry.namespace :"resource_registry.ui_metadatas" do

  register :validate do
    ResourceRegistry::UiMetadatas::Validation::UiMetadataContract.new
  end
end
