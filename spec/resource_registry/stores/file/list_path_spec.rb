# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Stores::File::ListPath do
  include RegistryDataSeed

  subject { described_class.new }

  context 'When folder is passed' do
    let(:config_folder) { features_folder_path }

    it "should return success with list of files" do
      expect(subject.call(config_folder).success?).to be_truthy
      expect(subject.call(config_folder).value!).to be_present
    end

    it "should return only files" do
      result = subject.call(config_folder).value!

      result.each do |path|
        expect(File.exist?(path)).to be_truthy
      end
    end
  end
end
