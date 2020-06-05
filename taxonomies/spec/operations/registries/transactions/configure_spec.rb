# frozen_string_literal: true

require 'spec_helper'
require 'support/initialize_registry'
# require 'resource_registry/registries/transactions/configure'
# require 'resource_registry/registries/validation/registry_contract'

RSpec.describe ResourceRegistry::Registries::Transactions::Configure do
  include RegistryDataSeed

  before(:all) do
    reset_registry
    initialize_registry
  end

  after(:all) do
    reset_registry
  end

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
    configuration_options_hash[:resource_registry][:config].each_pair do |key, _value|
      expect(Registry.keys).not_to include("resource_registry.config.#{key}")
    end
  end

  context "when valid configuration options passed" do

    subject { described_class.new.call(configuration_options_with_resolver_options) }

    before(:all) do
      initialize_registry
    end

    after do
      reset_registry
    end

    it "should load application & resource registry configuration" do
      subject

      configuration_options_hash[:application][:config].each_pair do |key, value|
        expect(Registry.config.send(key)).to eq value
      end

      configuration_options_hash[:resource_registry][:config].each_pair do |key, value|
        expect(Registry["resource_registry.config.#{key}"]).to eq value
      end
    end
  end
end