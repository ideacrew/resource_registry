# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Validation::Settings::SettingContract do

  let(:key)     { :my_key }
  let(:value)   { "setting value attribute value" }
  let(:meta)    { { label: "label", default: 42, type: :integer } }

  let(:required_params) { { key: key, value: value } }
  let(:optional_params) { { meta: meta } }
  let(:all_params)      { required_params.merge(optional_params) }

  context "Given invalid parameters" do
    context "and parameters are empty" do
      it { expect(subject.call({}).success?).to be_falsey }
      it { expect(subject.call({}).error?(:key)).to be_truthy }
    end

    context "and :key parameter only" do
      it { expect(subject.call({key: key}).success?).to be_falsey }
      it { expect(subject.call({key: key}).error?(:value)).to be_truthy }
    end

    context "and :value parameter only" do
      it { expect(subject.call({value: value}).success?).to be_falsey }
      it { expect(subject.call({value: value}).error?(:key)).to be_truthy }
    end

    context "and :meta params are invalid" do
      let(:invalid_meta)    { { meta: { label: "" } } }
      let(:invalid_params)  { required_params.merge(invalid_meta) }

      it { expect(subject.call(invalid_params).success?).to be_falsey }
      it { expect(subject.call(invalid_params).errors.messages.first.path).to include(:meta) }
    end

  end

  context "Given valid parameters" do
    context "and required parameters only" do
      it { expect(subject.call(required_params).success?).to be_truthy }
    end

    context "and required and optional parameters" do
      it { expect(subject.call(all_params).success?).to be_truthy }
    end

    context "and key is passed as string" do
        let(:key_string)  { "my_key" }
        let(:params)      { { key: key_string, value: value } }

      it "should coerce stringified key into symbol" do
        expect(subject.call({key: key, value: value}).success?).to be_truthy
        expect(subject.call({key: key, value: value}).to_h[:key]).to be_a Symbol
      end

    end

  end
end
