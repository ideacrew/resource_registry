# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Serializers::Yaml::Serialize do
  include RegistryDataSeed

  subject { described_class.new.call(input) }

  context 'When valid file IO passed' do

    let(:deserializer)  { ResourceRegistry::Serializers::Yaml::Deserialize.new }

    let(:source_yaml)   { IO.read(File.open(configuration_file_path)) }
    let(:input)         { deserializer.call(source_yaml).value! }

    it "should return success with hash output" do
      expect(subject).to be_a Dry::Monads::Result::Success
      expect(subject.value!).to be_a String
    end

    it "should return options yaml" do
      expect(subject.value!.strip!).to eq source_yaml.strip!
    end
  end
end