# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Serializers::Operations::ParseYaml do
  # include RegistryDataSeed

  subject { described_class.new.call(input) }

  context 'When valid file IO passed' do

    let(:input) { IO.read(options_file_path) }

    it "should return success with hash output" do
      expect(subject).to be_a Dry::Monads::Result::Success
      expect(subject.value!).to be_a Hash
    end

    it "should return options hash" do
      expect(subject.value!).to eq options_hash
    end
  end
end
