# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Validation::Configurations::ConfigurationContract do

  let(:name)              { :my_registry }
  let(:root)              { Pathname.new('./lib') }
  let(:created_at)        { DateTime.now }
  let(:register_meta)     { false }
  let(:system_dir)        { '/system/boot' }
  let(:default_namespace) { 'feature_index' }
  let(:auto_register)     { ['/options'] }
  let(:load_path)         { 'stores' }
  let(:settings)          { [{ key: :service, item: "weather/forecast" }, { key: :retries, item: 4 }] }

  let(:required_params) { { name: name, root: root, created_at: created_at, register_meta: register_meta, } }
  let(:optional_params) {
    {
      system_dir:         system_dir,
      default_namespace:  default_namespace,
      auto_register:      auto_register,
      load_path:          load_path,
      settings:           settings,
    }
  }

  let(:all_params)      { required_params.merge(optional_params) }

  context "Given invalid parameters" do
    context "and parameters are empty" do
      it { expect(subject.call({}).success?).to be_falsey }
      it { expect(subject.call({}).error?(:name)).to be_truthy }
    end

    context "with optional parameters only" do
      it { expect(subject.call(optional_params).success?).to be_falsey }
      it { expect(subject.call(optional_params).error?(:name)).to be_truthy }
    end

    context "and a non-boolean value is passed to :register_meta" do
      let(:invalid_register_meta)  { "blue" }
      let(:invalid_params)      { required_params.merge(register_meta: invalid_register_meta) }
      let(:error_message)       { "must be boolean" }

      it "should should fail validation" do
        result = subject.call(invalid_params)

        expect(result.success?).to be_falsey
        expect(result.errors.first.text).to eq error_message
      end
    end
  end

  context "Given valid parameters" do
    context "and required parameters only" do
      it { expect(subject.call(required_params).success?).to be_truthy }
      it { expect(subject.call(required_params).to_h).to eq required_params }
    end

    context "and all required and optional parameters" do
      it { expect(subject.call(all_params).success?).to be_truthy }
      it { expect(subject.call(all_params).to_h).to eq all_params }
    end

    context "and name is passed as string" do
      let(:name_string) { "my_registry" }
      let(:params)      { required_params.merge(name: name_string) }

      it "should coerce stringified key into symbol" do
        result = subject.call(params)

        expect(result.success?).to be_truthy
        expect(result[:name]).to eq name
      end
    end
  end

  describe "root attribute coercion and validation" do
    context "root is passed as a String" do
      let(:root_string)   { './lib' }
      let(:params)        { required_params.merge({root: root_string}) }

      it "should coerce the :root value to a Pathname" do
        result = subject.call(params)

        expect(result.success?).to be_truthy
        expect(result.to_h).to eq required_params
      end
    end

    context "root path doesn't exist" do
      let(:root_string)     { './zzzzzzzz' }
      let(:invalid_path)    { Pathname.new(root_string) }
      let(:invalid_params)  { required_params.merge({root: root_string}) }
      let(:error_hash)      { {:root=>["pathname not found: ./zzzzzzzz"]} }

      it "should fail validation" do
        expect{invalid_path.realpath}.to raise_error Errno::ENOENT

        result = subject.call(invalid_params)

        expect(result.success?).to be_falsey
        expect(result.errors.to_h).to eq error_hash
      end
    end
  end

end
