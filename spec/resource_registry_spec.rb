require 'spec_helper'

RSpec.describe ResourceRegistry do
  include RegistryDataSeed

  before(:all) do
    reset_registry
  end

  it 'should have Registry container' do
    expect(Registry).to be_present
  end

  it 'should have transaction pre registered' do
    expect(Registry.keys.any?{|k| k.scan(/resource_registry.transactions/).present?}).to be_truthy
  end

  it 'should have operations pre registred' do
    expect(Registry.keys.any?{|k| k.scan(/resource_registry.operations/).present?}).to be_truthy
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

  context ".configure" do

    before(:all) do
      ResourceRegistry.configure do
        {
          application: {
            config: {
              name: "EdiApp",
              default_namespace: "options",
              root: '.',
              system_dir: "system",
              auto_register: []
              },
              load_paths: ['system']
          }
        }
      end
    end

    it "should load application configuration" do
      expect(Registry.config.name).to eq 'EdiApp'
      expect(Registry.config.root).to eq Pathname.new('.')
      expect(Registry.config.system_dir).to eq 'system'
      expect(Registry.config.default_namespace).to eq 'options'
    end

    it "should load resource registry configuration" do
      configuration_options_hash['resource_registry']['config'].each_pair do |key, value|
        if key == 'root'
          value = Pathname.new(value)
        end
        expect(Registry["resource_registry.config.#{key}"]).to eq value
      end
    end
  end

  context ".load_options" do

    before(:all) do
      @result = ResourceRegistry.load_options!(option_files_dir)
    end

    it "loads successfully" do
      expect(@result.success?).to be_truthy
    end

    it 'should load site options' do
      expect(Registry.keys.include?("tenants.dchbx.applications.enroll.features")).to be_truthy
    end

    it 'should load individual market options' do
      expect(Registry.keys.any?{|key| key.scan(/tenants.dchbx.applications.enroll.features.individual_market/).present?}).to be_truthy
    end

    it 'should load shop market options' do
      expect(Registry.keys.any?{|key| key.scan("tenants.dchbx.applications.enroll.features.aca_shop_market").present?}).to be_truthy
    end
  end
end