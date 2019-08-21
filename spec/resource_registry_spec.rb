# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry do
  include RegistryDataSeed

  before(:all) do
    reset_registry
  end

  after(:all) do
    reset_registry
  end

  context ".configure" do
    let(:config) do
      {
        config: {
          name: "EdiApp",
          default_namespace: "options",
          root: Pathname.pwd.join('spec', 'rails_app'),
          system_dir: "system",
          auto_register: []
        },
        env: :production,
        load_paths: ['system']
      }
    end

    before(:all) do
      initialize_registry
      load_dependencies
    end

    it 'should create Registry container' do
      expect(Registry).to be_present
    end

    it 'should register transactions/operations dependencies' do
      expect(Registry.keys.any?{|k| k.scan(/resource_registry.serializers/).present?}).to be_truthy
      expect(Registry.keys.any?{|k| k.scan(/resource_registry.registries/).present?}).to be_truthy
      expect(Registry.keys.any?{|k| k.scan(/resource_registry.stores/).present?}).to be_truthy
      expect(Registry.keys.any?{|k| k.scan(/resource_registry.enterprises/).present?}).to be_truthy
    end

    it 'should not load application configuration' do
      expect(Registry.config.name).to be_nil
      expect(Registry.config.root).to eq Pathname.pwd
      expect(Registry.config.system_dir).to eq 'system'
      expect(Registry.config.default_namespace).to be_nil
    end

    it 'should not load resource registry configuration' do
      configuration_options_hash[:resource_registry][:config].each_pair do |key, _value|
        expect(Registry.keys).not_to include("resource_registry.config.#{key}")
      end
    end

    it 'should set a config variable with application configuration' do
      expect(ResourceRegistry.config).to be_present
      expect(ResourceRegistry.config.to_h).to eq config
    end
  end

  context ".create" do
    before do
      initialize_registry
      ResourceRegistry.create
    end

    it "should load application configuration" do
      expect(Registry.config.name).to eq 'EdiApp'
      expect(Registry.config.root).to eq Pathname.pwd.join('spec', 'rails_app')
      expect(Registry.config.system_dir).to eq 'system'
      expect(Registry.config.default_namespace).to eq 'options'
    end

    it "should load resource registry configuration" do
      configuration_options_hash[:resource_registry][:config].each_pair do |key, value|
        test_value = (key == :root) ? Pathname.new(value) : value
        if test_value.present?
          expect(Registry["resource_registry.config.#{key}"]).to eq test_value
        end
      end
    end

    it 'should load site options' do
      expect(Registry.keys.include?("enterprise.dchbx.shop_site.production.copyright_period_start")).to be_truthy
      expect(Registry.keys.include?("enterprise.dchbx.shop_site.production.policies_url")).to be_truthy
    end

    it 'should load shop market options' do
      expect(Registry.keys.any?{|key| key.scan(/enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.small_market_employee_count_maximumt/).present?}).to be_truthy
    end

    # it 'should load individual market options' do
    #   expect(Registry.keys.any?{|key| key.scan("tenants.dchbx.applications.enroll.features.aca_shop_market").present?}).to be_truthy
    # end
  end

  context 'when wrong initializer configuration passed' do
    let(:initializer_config) {
      {
        application: {
          config: {
            name: "EdiApp",
            default_namespace: "options",
            system_dir: "system",
            auto_register: []
          },
          load_paths: ['system']
        }
      }.merge(resolver_options_hash)
    }

    it 'should throw an error' do
      begin
        ResourceRegistry.configure { initializer_config }
      rescue ResourceRegistry::Error::InitializationFileError => e
        expect(e).to be_present
      end
    end
  end
end