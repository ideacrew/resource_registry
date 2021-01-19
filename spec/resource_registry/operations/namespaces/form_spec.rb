# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Namespaces::Form do
  include RegistryDataSeed

  subject { described_class.new.call(namespace: [:shop, :"2021"], registry: registry) }

  context 'When a valid namespace passed' do
    let(:registry) do
      registry = ResourceRegistry::Registry.new
      registry.register('configuration.load_path', features_folder_path)
      registry
    end

    before do
      ResourceRegistry::Operations::Registries::Load.new.call(registry: registry)
    end

    it "should return namespace entity" do
      subject

      expect(subject).to be_a Dry::Monads::Result::Success
      expect(subject.value!).to be_a ResourceRegistry::Namespace
    end
  end
end
