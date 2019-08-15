require 'spec_helper'
require 'support/registry_configure'
require 'resource_registry/registries/transactions/load_dependency'

RSpec.describe ResourceRegistry::Registries::Transactions::LoadDependency do
  include RegistryDataSeed

  context 'When valid option passed' do  

    let(:step_dependencies) {
      [
        'resource_registry.options.load',
        'resource_registry.serializers.parse_option',
        'resource_registry.enterprises.generate',
        'resource_registry.serializers.generate_container',
        'resource_registry.stores.persist_container'
      ]
    }

    it 'should have Registry container' do
      expect(Registry).to be_present
    end

    it 'should have dependencies registered on container' do
      step_dependencies.each do |dependency|
        expect(Registry.keys.include?(dependency)).to be_truthy
      end
    end

    context "when valid configuration options passed" do
      subject { described_class.new.call(options_file_path) }

      it 'should load options' do
        subject
        expect(Registry.keys.include?("tenants.dchbx.applications.enroll.features")).to be_truthy
        expect(Registry.keys.include?("tenants.dchbx.applications.edi.features")).to be_truthy
      end
    end
  end
end