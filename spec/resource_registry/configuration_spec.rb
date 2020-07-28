# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Configuration do

  let(:name)              { :my_registry }
  let(:root)              { Pathname.new('./lib') }
  let(:created_at)        { DateTime.now }
  let(:register_meta)     { false }
  let(:system_dir)        { '/system/boot' }
  let(:default_namespace) { 'feature_index' }
  let(:auto_register)     { ['/options'] }
  let(:load_path)         { 'stores' }
  let(:settings)          { [{ key: :service, item: "weather/forcast" }, { key: :retries, item: 4 }] }

  let(:required_params) { { name: name, root: root, created_at: created_at, register_meta: register_meta } }
  let(:optional_params) do
    {
      system_dir: system_dir,
      default_namespace: default_namespace,
      # auto_register:      auto_register,
      load_path: load_path
      # settings:           settings,
    }
  end

  let(:all_params)      { required_params.merge(optional_params) }


  context "Validation with invalid input" do
    context "Given hash params are missing required attributes" do
      it "should fail validation" do
        expect{described_class.new}.to raise_error Dry::Struct::Error
      end
    end
  end

  context "Validation with valid input" do
    context "Given hash params include only required attributes" do
      it "should pass validation" do
        expect(described_class.new(required_params)).to be_a ResourceRegistry::Configuration
        expect(described_class.new(required_params).to_h).to eq required_params
      end
    end

    context "Given hash params include all required and optional attributes" do
      it "should pass validation" do
        expect(described_class.new(all_params)).to be_a ResourceRegistry::Configuration
        expect(described_class.new(all_params).to_h).to eq all_params
      end
    end
  end

end
