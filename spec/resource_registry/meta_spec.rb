# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Meta do

  let(:label)       { "Name of this UI Feature" }
  let(:type)        { :integer }
  let(:default)     { 42 }
  let(:value)       { 57 }
  let(:description) { "The Answer to Life, the Universe and Everything" }
  let(:enum)        { [] }
  let(:is_required) { false }
  let(:is_visible)  { false }

  let(:required_params)   { { label: label, type: type, default: default, } }
  let(:optional_params)   { {
                              value: value,
                              description: description,
                              enum: enum,
                              is_required: is_required,
                              is_visible: is_visible,
                            }
                            }
  let(:all_params)        { required_params.merge(optional_params) }

  context "Validation with valid input" do
    context "Given hash params include only required attributes" do
      it "should pass validation" do
        expect(described_class.new(required_params)).to be_a ResourceRegistry::Meta
        expect(described_class.new(required_params).to_h).to eq required_params
      end
    end

    context "Given hash params include all required and optional attributes" do
      it "should pass validation" do
        expect(described_class.new(all_params)).to be_a ResourceRegistry::Meta
        expect(described_class.new(all_params).to_h).to eq all_params
      end
    end
  end
end
