# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Features::Create do
  include RegistryDataSeed

  subject { described_class.new.call(feature_params) }

  context 'When valid feature hash passed' do

    let(:file_io)        { ResourceRegistry::Stores::File::Read.new.call(feature_template_path).value! }
    let(:yml_params)     { ResourceRegistry::Serializers::Yaml::Deserialize.new.call(file_io).value! }
    let(:feature_params) { ResourceRegistry::Serializers::Features::Serialize.new.call(yml_params).value!.first }

    it "should return success with hash output" do
      subject
      
      expect(subject).to be_a Dry::Monads::Result::Success
      expect(subject.value!).to be_a ResourceRegistry::Feature
    end
  end
end