# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Validation::FeatureContract do

  describe "Feature core parameters" do
    let(:key)         { :my_feature }
    let(:namespace)   { {path: [:level_1, :level_2, :level_3]} }
    let(:is_enabled)  { false }
    let(:item)        { ->(val){ val.to_sym } }
    let(:options)     { { name: "Dolly" } }
    let(:meta)        { { label: "label", default: 42, content_type: :integer } }
    let(:settings)    { [{ key: :service, item: "weather/forecast" }, { key: :retries, item: 4 }] }

    let(:required_params)     { { key: key, namespace_path: namespace, is_enabled: is_enabled, item: item } }
    let(:optional_params)     { { options: options, meta: meta, settings: settings } }
    let(:all_params)          { required_params.merge(optional_params) }

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
        let(:invalid_params)      { { key: key, namespace_path: namespace, is_enabled: invalid_is_enabled } }
        let(:error_message)       { "must be boolean" }

        it "should should fail validation" do
          result = subject.call(invalid_params)

          expect(result.success?).to be_falsey
          expect(result.errors.first.text).to eq error_message
        end
      end

      context 'namespace missing' do
        let(:invalid_params) { required_params.merge(namespace_path: nil) }

        it "should should fail validation" do
          result = subject.call(invalid_params)

          expect(result.success?).to be_falsey
          expect(result.errors[:namespace_path]).to eq ["must be a hash"]
        end
      end
    end

    context "Given valid parameters" do
      let(:required_attr_defaults)  { {meta: nil, settings: []} }
      let(:required_attr_out)     { required_params.merge(required_attr_defaults) }

      context "and required parameters only" do
        it { expect(subject.call(required_params).success?).to be_truthy }
        it { expect(subject.call(required_params).to_h).to eq required_attr_out }
      end

      context "and all required and optional parameters" do

        it "should pass validation" do
          result = subject.call(all_params)

          expect(result.success?).to be_truthy
          expect(result.to_h).to eq all_params
        end
      end

      context "and key is passed as string" do
        let(:key_string)  { "my_feature" }
        let(:params)      { { key: key_string, namespace_path: namespace, is_enabled: is_enabled } }

        it "should coerce stringified key into symbol" do
          result = subject.call(params)

          expect(result.success?).to be_truthy
          expect(result[:key]).to eq key
        end
      end

      context "and passing namespace values in as strings" do
        let(:namespace_strings)   { {path: ['level_1', 'level_2', 'level_3']} }
        let(:params)              { { key: key, namespace_path: namespace_strings, is_enabled: is_enabled, item: item } }

        it "should coerce stringified key into symbol" do
          result = subject.call(params)

          expect(result.success?).to be_truthy
          expect(result.to_h).to eq required_attr_out
        end
      end

      context "and date range string passed as setting item" do
        let(:key_string)  { "my_feature" }
        let(:settings)    { [{ key: 'effective_period', item: "2020-01-01..2020-01-31" }, { key: 'retries', item: 4 }] }

        it "should coerce date range string to actual dates" do
          result = subject.call(all_params)

          expect(result.success?).to be_truthy
          expect(result[:key]).to eq key
          expect(result[:settings][0][:item]).to eq Date.new(2020,1,1)..Date.new(2020,1,31)
        end
      end
    end
  end
end
