require 'spec_helper'

RSpec.describe ResourceRegistry::Services::LoadRegistryOptions do
  include RegistryDataSeed

  subject { described_class.new.call(input) }

  before(:all) do
    reset_registry
  end
  
  context 'When valid option passed' do  

    let(:step_dependencies) {
      [
        'resource_registry.operations.load',
        'resource_registry.operations.parse',
        'resource_registry.transactions.transform_option',
        'resource_registry.operations.generate_container',
        'resource_registry.operations.persist'
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

      before(:all) do
        ResourceRegistry::Services::LoadRegistryOptions.new.call(options_file_path)
      end

      it 'should load options' do
        expect(Registry.keys.include?("tenants.dchbx.applications.enroll.features")).to be_truthy
        expect(Registry.keys.include?("tenants.dchbx.applications.edi.features")).to be_truthy
      end
    end
  end
end
