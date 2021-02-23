# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Setting do

  before do
    module ResourceRegistry
      class Greeter
        def call(params)
          "Hello #{params[:name]}"
        end
      end
    end
  end

  let(:key)     { :my_key }
  let(:item)    { ResourceRegistry::Greeter.new }
  let(:options) { { name: "Dolly" } }
  let(:meta)    { { label: "label", default: 42, content_type: :integer } }

  let(:required_params) { { key: key, item: item } }
  let(:optional_params) { { meta: meta, options: options } }
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

    context "Given nil for item attribute" do
      let(:nil_item)   { nil }
      let(:params)     { { key: key, item: nil_item } }

      it "should pass validation" do
        expect(described_class.new(params)).to be_a ResourceRegistry::Setting
        expect(described_class.new(params).to_h).to eq params
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
