require 'spec_helper'

RSpec.describe ResourceRegistry::Serializers::Operations::GenerateContainer do
  include RegistryDataSeed

  subject { described_class.new.call(input) }

  context 'When valid option passed' do  

    let(:input) {
      options_hash.deep_symbolize_keys!
      ResourceRegistry::Entities::Option.new(options_hash)
    }

    let(:expected_keys) {
      [
        "tenants.dchbx.applications.enroll.features.enroll_main.test_setting",
        "tenants.dchbx.applications.enroll.features",
        "tenants.dchbx.applications.edi.features",
        "tenants.dchbx.owner",
        "tenants.dchbx.subscriptions"
      ]
    }

    it "should return success with container object" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to be_a Dry::Container
    end

    it "should have keys registered" do
      expect(subject.value!.keys.sort).to eq(expected_keys.sort)
    end
  end
end
