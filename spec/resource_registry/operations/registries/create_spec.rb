# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Registries::Create do
  include RegistryDataSeed

  subject { described_class.new.call(path: path, registry: registry) }

  context 'When valid feature hash passed' do
    let(:path)     { feature_template_path }
    let(:registry) { ResourceRegistry::Registry.new }

    it "should return success with hash output" do
      subject
      expect(subject).to be_a Dry::Monads::Result::Success
      expect(subject.value!).to include(a_kind_of ResourceRegistry::Feature)
    end
  end

  context 'When invalid features' do
    let(:path)     { invalid_feature_template_path }
    let(:registry) { ResourceRegistry::Registry.new }

    it "should return success with hash output" do
      subject
      expect(subject).to be_a Dry::Monads::Result::Failure
      expect(subject.failure.errors[:namespace_path]).to eq [{:text=>"invalid meta", :error=>{:path=>["must be an array"]}}]
    end
  end
end