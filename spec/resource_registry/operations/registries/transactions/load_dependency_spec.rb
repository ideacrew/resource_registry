# frozen_string_literal: true

require 'spec_helper'
require 'support/registry_configure'
# require 'resource_registry/registries/transactions/load_dependency'

RSpec.describe ResourceRegistry::Registries::Transactions::LoadDependency do
  include RegistryDataSeed

  before(:all) do
    configure_registry unless defined? Registry
  end

  after(:all) do
    reset_registry
  end

  context 'When valid option passed' do

    let(:step_dependencies) do
      [
        'resource_registry.options.load',
        'resource_registry.serializers.parse_option',
        'resource_registry.enterprises.generate',
        'resource_registry.serializers.generate_container',
        'resource_registry.stores.persist_container'
      ]
    end

    let(:file_path) do
      ResourceRegistry.config.to_h[:config][:root].join('system', 'config', 'enterprise.yml')
    end

    it 'should have Registry container' do
      expect(Registry).to be_present
    end

    it 'should have dependencies registered on container' do
      step_dependencies.each do |dependency|
        expect(Registry.keys.include?(dependency)).to be_truthy
      end
    end

    context "when valid configuration options passed" do
      subject { described_class.new.call(file_path) }

      it 'should load options' do
        subject
        expect(Registry.keys.any?{|key| key.match(/enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market/).present?}).to be_truthy
      end
    end
  end
end