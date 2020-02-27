# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Serializers::Features::Serialize do
  include RegistryDataSeed

  subject { described_class.new.call(input) }

  context 'When valid feature hash passed' do

    let(:serializer)    { ResourceRegistry::Serializers::Features::Serialize.new }
    let(:source_yaml)   { IO.read(File.open(feature_template_path)) }
    let(:input)         { ResourceRegistry::Serializers::Yaml::Deserialize.new.call(source_yaml).value! }

    it "should return success with hash output" do
      subject
      # expect(subject).to be_a Dry::Monads::Result::Success
      # expect(subject.value!).to be_a String
    end

    it "should return options yaml" do
      expect(subject.value!).to eq source_yaml
    end
  end
end