require 'spec_helper'

RSpec.describe ResourceRegistry::Stores::Operations::LoadFile do
  include RegistryDataSeed

  subject { described_class.new.call(input) }

  context 'When valid input hash passed' do

    let(:input) { options_file_path }

    it "should return success with file io" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to be_present
    end
  end
end
