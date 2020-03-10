# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Registries::Configure do
  include RegistryDataSeed

  subject { described_class.new.call(registry, config_params) }

  context 'When valid feature hash passed' do

    let(:config_params) {
      {
        name: :enroll,
        load_path: 'system/templates'
      }
    }

    let(:registry) { ResourceRegistry::Registry.new(key: :enroll) }


    it "should return success with registry as output" do
      subject
      expect(subject).to be_a Dry::Monads::Result::Success
      expect(subject.value!).to be_a ResourceRegistry::Registry
    end

    it "should register configuration values onto registry" do
      result = subject.value!
      expect(result['configuration.name']).to eq config_params[:name]
      expect(result['configuration.load_path']).to eq config_params[:load_path]
      expect(result['configuration.register_meta']).to eq false
    end
  end
end
