# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Validation::Features::FeatureContract do

  describe "Feature core parameters" do
    let(:key)         { :my_feature }
    let(:namespace)   { [:level_1, :level_2, :level_3 ]}
    let(:is_enabled)  { false }
    let(:item)        { ->(val){ val.to_sym } }
    let(:options)     { { name: "Dolly" } }
    let(:meta)        { { label: "label", default: 42, type: :integer } }
    let(:settings)    { [{ service: "weather/forcast" }, { retries: 4 }] }

    let(:required_params)     { { key: key, namespace: namespace, is_enabled: is_enabled, item: item } }
    let(:optional_params)     { { options: options, meta: meta, settings: settings } }
    let(:all_params)          { required_params.merge(optional_params) }
    let(:key_coercion_params) { {key: key.to_s } }

    context "Given invalid parameters" do
      context "and parameters are empty" do
        it { expect(subject.call({}).success?).to be_falsey }
        it { expect(subject.call({}).error?(:key)).to be_truthy }
      end

      context "with optional parameters only" do
        it { expect(subject.call(optional_params).success?).to be_falsey }
        it { expect(subject.call(optional_params).error?(:key)).to be_truthy }
      end

      context "and a non-boolean value is passed to :is_enabled" do
        let(:invalid_is_enabled)  { "blue" }
        let(:invalid_params)      { { key: key, namespace: namespace, is_enabled: invalid_is_enabled } }
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

      context "and key is passed as string" do
        let(:key_string)  { "my_feature" }
        let(:params)      { { key: key_string, namespace: namespace, is_enabled: is_enabled } }

        it "should coerce stringified key into symbol" do
          result = subject.call(params)

          expect(result.success?).to be_truthy
          expect(result[:key]).to eq key
        end
      end

      context "and passing namespace values in as strings" do
        let(:namespace_strings) { namespace.map(&:to_s ) }
        let(:params)            { { key: key, namespace: namespace_strings, is_enabled: is_enabled } }

        it "should coerce stringified key into symbol" do
          result = subject.call(params)

          expect(result.success?).to be_truthy
          expect(result.to_h).to eq required_params
        end

      end

    end
  end
end
