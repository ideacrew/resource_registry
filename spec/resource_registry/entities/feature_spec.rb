# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Feature do

  before do
    class ::Greeter
      def call(params)
        return "Hello #{params[:name]}"
      end
    end
  end

  let(:key)         { :greeter_feature }
  let(:namespace)   { [:level_1, :level_2, :level_3 ]}
  let(:is_enabled)  { false }
  let(:item)        { Greeter.new }
  let(:options)     { { name: "Dolly" } }
  let(:meta)        { { label: "label", default: 42, type: :integer } }
  let(:settings)    { [{ key: :service, item: "weather/forcast" }, { key: :retries, item: 4 }] }

  let(:required_params) { { key: key, namespace: namespace, is_enabled: is_enabled, item: item } }
  let(:optional_params) { { options: options, meta: meta, settings: settings } }
  let(:all_params)      { required_params.merge(optional_params) }

  let(:required_attr_defaults)  { { meta: {} } }
  let(:required_attr_out)       { required_params.merge(required_attr_defaults) }

  context "Validation with invalid input" do
    context "Given hash params are missing required attributes" do
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
        expect(described_class.new(required_params).to_h).to eq required_attr_out
      end
    end

    context "Given hash params include all required and optional attributes" do
      it "should pass validation" do
        expect(described_class.new(all_params)).to be_a ResourceRegistry::Feature
        expect(described_class.new(all_params).to_h).to eq all_params
      end
    end

    context "Given nil for item attribute" do
      let(:nil_item)   { nil }
      let(:params)     { required_params.select { |k,v| k != :item }.merge({item: nil_item}) }
      let(:attr_out)   { required_attr_out.merge(item: nil) }

      it "should pass validation" do
        expect(described_class.new(params)).to be_a ResourceRegistry::Feature
        expect(described_class.new(params).to_h).to eq attr_out
      end
    end
  end

  context "Given hash params include a class as the item value" do
    let(:greet_message) { "Hello " + options[:name] }

    it "should invoke the class with the passed options parameters" do
      setting = described_class.new(all_params)
      expect(setting[:item].call(setting[:options])).to eq greet_message
    end
  end
end
