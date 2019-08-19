require 'spec_helper'
require 'resource_registry/features/validation/feature_contract'

RSpec.describe ResourceRegistry::Features::Validation::FeatureContract do

  describe "Feature core parameters" do
    let(:key)         { :feature_key_value }
    let(:is_required) { false }
    let(:is_enabled)  { false }
    let(:alt_key)     { :alt_key_value }
    let(:title)       { "title_value" }
    let(:description) { "description_value" }
    let(:registry)    { Hash.new }
    let(:options)     { [] }
    let(:features)    { [] }

    let(:required_params)     { { key: key, is_required: is_required, is_enabled: is_enabled } }
    let(:optional_params)     { { alt_key: alt_key, title: title, description: description, registry: registry, options: options, features: features } }
    let(:all_params)          { required_params.merge(optional_params) }
    let(:key_coercion_params) { {key: key.to_s, alt_key: alt_key.to_s } }

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
    end

    context "with all required and optional parameters" do
      it { expect(subject.call(all_params).success?).to be_truthy }
      it { expect(subject.call(all_params).to_h).to eq all_params }
    end

    context "and passing in keys as strings" do
      it "should coerce all stringified keys into hashes" do
        result = subject.call(key_coercion_params.merge({is_required: is_required})).to_h

        expect(result[:key]).to eq key
        expect(result[:alt_key]).to eq alt_key
      end
    end
  end
end
