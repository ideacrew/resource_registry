# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Entities::Meta do

  let(:title)       { "Minimum days for Open Enrollment" }
  let(:type)        { :integer }
  let(:default)     { 5 }
  let(:value)       { 5 }
  let(:description) { "Shortest period in days that a group must offer open enrollment" }
  let(:choices)     { nil }
  let(:is_required) { true }
  let(:is_visible)  { true }

  let(:required_params)   { { title: title, type: type, default: default } }
  let(:optional_params)   { {
                              value: value,
                              description: description,
                              choices: choices,
                              is_required: is_required,
                              is_visible: is_visible,
                            }
                            }

  let(:all_params)        { required_params.merge(optional_params) }


  context "Validation with valid input" do
    context "Given hash params include required attributes" do
      it "should pass validation" do
        expect(described_class.new(required_params)).to be_a ResourceRegistry::Entities::UiMetadata
        expect(described_class.new(required_params).to_h).to eq required_params
      end
    end

    context "Given hash params include all required no optional attributes" do
      it "should pass validation" do
        expect(described_class.new(all_params)).to be_a ResourceRegistry::Entities::UiMetadata
        expect(described_class.new(all_params).to_h).to eq all_params
      end
    end
  end

end
