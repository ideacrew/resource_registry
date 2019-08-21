# frozen_string_literal: true

require 'spec_helper'
require 'support/initialize_registry'
require 'resource_registry/registries/transactions/load_application_configuration'

RSpec.describe ResourceRegistry::Registries::Transactions::LoadApplicationConfiguration do
  include RegistryDataSeed

  before do
    initialize_registry unless defined? Registry
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

    subject { described_class.new.call(configuration_file_path) }

    it "should load application & registry configuration" do
      subject

      override_config[:application][:config].each_pair do |key, value|
        test_value = (key == 'root') ? Pathname.new(value) : value
        expect(Registry.config.send(key)).to eq test_value
      end

      configuration_options_hash[:resource_registry][:config].each_pair do |key, value|
        test_value = (key == :root) ? Pathname.new(value) : value
        expect(Registry["resource_registry.config.#{key}"]).to eq test_value
      end
    end
  end
end