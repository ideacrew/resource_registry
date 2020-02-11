# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Features::Validation::FeatureContract do

  describe "Feature core parameters" do
    let(:key)         { :feature_key_value }
    let(:parent_key)  { :parent_key_value }
    let(:is_required) { false }
    let(:is_enabled)  { false }
    let(:options)     { [] }
    let(:features)    { [] }

    let(:ui_title)    { "title of this UI element" }
    let(:ui_type)     { :string }
    let(:ui_default)  { "default value for this element" }
    let(:ui_metadata) { { ui_title: ui_title, ui_type: ui_type, ui_default: ui_default } }

    let(:required_params)     { { key: key, parent_key: parent_key, is_required: is_required, is_enabled: is_enabled, ui_metadata: ui_metadata } }
    let(:optional_params)     { { options: options, features: features } }
    let(:all_params)          { required_params.merge(optional_params) }
    let(:key_coercion_params) { {key: key.to_s, parent_key: parent_key.to_s } }

    context "with no parameters" do
      it { expect(subject.call({}).success?).to be_falsey }
      it { expect(subject.call({}).error?(:key)).to be_truthy }
    end

    context "with optional parameters only" do
      it { expect(subject.call(optional_params).success?).to be_falsey }
      it { expect(subject.call(optional_params).error?(:key)).to be_truthy }
    end

    context "with required parameters only" do
      it { expect(subject.call(required_params).success?).to be_truthy }
      it { expect(subject.call(required_params).to_h).to eq required_params }
    end

    context "with all required and optional parameters" do
      it { expect(subject.call(all_params).success?).to be_truthy }
      it { expect(subject.call(all_params).to_h).to eq all_params }
    end

    context "and passing in keys as strings" do
      it "should coerce all stringified keys into hashes" do
        result = subject.call(key_coercion_params.merge({is_required: is_required})).to_h

        expect(result[:key]).to eq key
        expect(result[:parent_key]).to eq parent_key
      end
    end
  end
end
