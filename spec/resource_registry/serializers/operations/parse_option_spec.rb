# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Serializers::Operations::ParseOption do
  include RegistryDataSeed

  subject { described_class.new }

  context 'When valid file IO passed' do

    let(:input)       { IO.read(options_file_path) }
    let(:hash_output) { ResourceRegistry::Serializers::Operations::ParseYaml.new.call(input) }
    # let!(:option)      { ResourceRegistry::Serializers::Operations::GenerateOption.new.call(option_hash) }

    let(:option_hash) {
      options = hash_output.value!
      options.deep_symbolize_keys!
    }

    it "should return success with options object" do
      subject.call(option_hash)
    end
  end
end