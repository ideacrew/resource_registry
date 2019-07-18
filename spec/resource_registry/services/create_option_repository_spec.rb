require "spec_helper"
# require 'dry/container/stub'

RSpec.describe ResourceRegistry::Services::CreateOptionsRepository do

  subject { described_class }

  describe "Instantiating a repository" do
    let(:options_top_namespace)  { "options_repository" }
    let(:store_keys)        { 'file_store' }
    let(:serializer_keys)   { ['xml_serializer', 'yaml_serializer', 'options_serializer' ] }

    it "should return an option repository instance" do
      expect(subject.call).to be_a ResourceRegistry::Repository
      expect(subject.call.top_namespace).to eq options_top_namespace
    end

    it "should register keys for store and serializer classes" do
      expect(subject.call.keys).to include store_keys
      expect(subject.call.keys).to include *serializer_keys
    end
  end


end
