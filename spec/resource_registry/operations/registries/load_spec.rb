# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Registries::Load do
  include RegistryDataSeed

  subject { described_class.new.call(registry: registry) }

  context 'When valid feature hash passed' do

    let(:registry)   { ResourceRegistry::Registry.new }

    before do
      registry.register('configuration.load_path', features_folder_path)
    end

    it "should return success with hash output" do
      expect(subject).to be_a Dry::Monads::Result::Success
      expect(subject.value!).to be_a ResourceRegistry::Registry
    end

    it "should have features registered" do
    end
  end
end