# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Setting do

  let(:key)     { :my_key }
  let(:value)   { "setting value attribute value" }
  let(:meta)    { { label: "label", default: 42, type: :integer } }

  let(:required_params) { { key: key, value: value } }
  let(:optional_params) { { meta: meta } }
  let(:all_params)      { required_params.merge(optional_params) }

  context "Validation with invalid input" do
    context "Given hash params are nissing required attributes" do
      let(:error_hash)  { {} }

      it "should fail validation" do
        expect{described_class.new(optional_params)}.to raise_error Dry::Struct::Error
      end
    end
  end

  context "Validation with valid input" do
    context "Given hash params include only required attributes" do
      it "should pass validation" do
        expect(described_class.new(required_params)).to be_a ResourceRegistry::Setting
        expect(described_class.new(required_params).to_h).to eq required_params
      end
    end

    context "Given hash params include all required and optional attributes" do
      it "should pass validation" do
        expect(described_class.new(all_params)).to be_a ResourceRegistry::Setting
        expect(described_class.new(all_params).to_h).to eq all_params
      end
    end

    context "Given nil for value attribute" do
      let(:nil_value)   { nil }
      let(:params)      { { key: key, value: nil_value } }

      it "should pass validation" do
        expect(described_class.new(params)).to be_a ResourceRegistry::Setting
        expect(described_class.new(params).to_h).to eq params
      end
    end
  end
end
