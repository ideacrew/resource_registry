# frozen_string_literal: true

require 'resource_registry/serializers'

Registry.namespace :"resource_registry.serializers.yaml" do

  register :serialize do
    ResourceRegistry::Serializers::Yaml::Serialize.new
  end

  register :deserialize do
    ResourceRegistry::Serializers::Yaml::Deerialize.new
  end

end


Registry.namespace :"resource_registry.serializers" do

  register :parse_yaml do
    ResourceRegistry::Serializers::Operations::ParseYaml.new
  end

  register :parse_option do
    ResourceRegistry::Serializers::Operations::ParseOption.new
  end

  register :generate_option do
    ResourceRegistry::Serializers::Operations::GenerateOption.new
  end

  register :generate_entity do
    ResourceRegistry::Serializers::Operations::GenerateEntity.new
  end

  register :generate_container do
    ResourceRegistry::Serializers::Operations::GenerateContainer.new
  end

  register :symbolize_keys do
    ResourceRegistry::Serializers::Operations::SymbolizeKeys.new
  end

  register :transform do
    ResourceRegistry::Serialzers::GenerateOptions.new
  end
end