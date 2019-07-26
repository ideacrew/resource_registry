require "spec_helper"
require 'dry/container/stub'
require 'resource_registry/serializers'

RSpec.describe ResourceRegistry::Serializers::YamlSerializer do

  let(:base_dir)          { "./spec/system/local/registry" }
  let(:input_file_name)   { File.join(base_dir ,"registry.yml") }
  let(:output_file_name)  { File.join(base_dir ,"registry_out.yml") }

  context "parse yaml content into model structure" do

    it "should read the YAML input file" do
      yaml_hash = YAML.load(File.read(input_file_name))

      # repository = ResourceRegistry::Options::Application.parse(yaml_hash)
      # yaml_format = repository.to_yaml

      yaml_format = yaml_hash.to_yaml
      result = File.open(output_file_name, "w") { |file| file.write(yaml_format) }    
    end
  end


  context "serialize model structure into yaml" do
  end



end