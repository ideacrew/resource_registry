# frozen_string_literal: true
require "spec_helper"
# require 'dry/system/stubs'
require 'resource_registry' unless defined?(ResourceRegistry::CoreContainer)

RSpec.describe ResourceRegistry do
  skip "TODO Verify and update the spec" do
    subject { described_class }

    before do
      subject.enable_stubs!
      subject.finalize!
    end

    let(:config_name)       { :core }
    let(:option_key)        { 'options.store' }
    let(:stores_key)        { 'stores.file_store' }
    let(:serializer_key)    { 'serializers.yaml_serializer' }
    let(:injector_constant) { ResourceRegistry::CoreInject }

    it "should do somethiing!" do
      binding.pry
    end

    it { expect(subject).to respond_to(:boot, :config) }
    it { expect(subject.config.name).to eq config_name}
    it { expect(subject.keys).to include option_key }
    it { expect(subject.keys).to include stores_key }
    it { expect(subject.keys).to include serializer_key }

    it { expect(defined? injector_constant).to be_truthy }
  end
end