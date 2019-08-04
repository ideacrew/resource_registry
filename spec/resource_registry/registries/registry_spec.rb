require 'spec_helper'
require 'resource_registry/registries/registry'
require 'resource_registry/registries/validation/registry_contract'

RSpec.describe ResourceRegistry::Registries::Registry do
  include RegistryDataSeed

  it 'should have Registry container' do
    expect(Registry).to be_present
  end

  it 'should have default application configuration' do
    expect(Registry.config.name).to be_nil
    expect(Registry.config.root).to eq Pathname.pwd
    expect(Registry.config.system_dir).to eq 'system'
    expect(Registry.config.default_namespace).to be_nil
  end

  it 'should not have resource registry configuration' do
    configuration_options_hash['resource_registry']['config'].each_pair do |key, value|
      expect(Registry.keys).not_to include("resource_registry.config.#{key}")
    end
  end

  context "when valid configuration options passed" do

    before(:all) do
      ResourceRegistry::Registries::Registry.new.call(configuration_options_hash)
    end

    it "should load application configuration" do
      configuration_options_hash['application']['config'].each_pair do |key, value|
        expect(Registry.config.send(key)).to eq value
      end
    end

    it "should load resource registry configuration" do
      configuration_options_hash['resource_registry']['config'].each_pair do |key, value|
        expect(Registry["resource_registry.config.#{key}"]).to eq value
      end
    end
  end
end