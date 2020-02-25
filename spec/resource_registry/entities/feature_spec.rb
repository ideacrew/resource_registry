# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Feature do

  let(:key)         { :my_feature }
  let(:namespace)   { [:level_1, :level_2, :level_3 ]}
  let(:is_enabled)  { false }
  let(:meta)        { { label: "label", default: 42, type: :integer } }
  let(:settings)    { [{ key: :service, value: "weather/forcast" }, { key: :retries, value: 4 }] }

  let(:required_params)     { { key: key, namespace: namespace, is_enabled: is_enabled } }
  let(:optional_params)     { { meta: meta, settings: settings } }
  let(:all_params)          { required_params.merge(optional_params) }

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
        expect(described_class.new(required_params)).to be_a ResourceRegistry::Feature
        expect(described_class.new(required_params).to_h).to eq required_params
      end
    end

    context "Given hash params include all required and optional attributes" do
      it "should pass validation" do
        expect(described_class.new(all_params)).to be_a ResourceRegistry::Feature
        expect(described_class.new(all_params).to_h).to eq all_params
      end
    end
  end
end
