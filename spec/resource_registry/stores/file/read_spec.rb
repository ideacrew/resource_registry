# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Stores::File::Read do
  include RegistryDataSeed

  subject { described_class.new }

  context 'When valid file name is passed' do
    let(:valid_file) { feature_template_path.to_s }

    it "the file should exist" do
      expect(::File.exist?(valid_file)).to be_truthy
    end

    it "should return success with file io" do
      expect(subject.call(valid_file).success?).to be_truthy
      expect(subject.call(valid_file).value!).to be_present
    end
  end

  context 'When a non-existent file name is passed' do
    let(:invalid_file)  { "zzz/zzz/zzz" }
    let(:no_file_error) { ["No such file or directory", {:params => "zzz/zzz/zzz"}] }

    it "the file should not exist" do
      expect(::File.exist?(invalid_file)).to be_falsey
    end

    it "should return failure with no file found error" do
      expect(subject.call(invalid_file).failure?).to be_truthy
      expect(subject.call(invalid_file).failure).to eq no_file_error
    end
  end
end
