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

  context "#item date range normalization" do
    it "parses YYYY-MM-DD..YYYY-MM-DD as a date range" do
      setting = described_class.new(key: :period, item: "2025-1-1..2025-12-1")
      expect(setting.item).to eq(Date.new(2025, 1, 1)..Date.new(2025, 12, 1))
    end

    it "parses YYYY/MM/DD..YYYY/MM/DD as a date range" do
      setting = described_class.new(key: :period, item: "2025/01/01..2025/12/1")
      expect(setting.item).to eq(Date.new(2025, 1, 1)..Date.new(2025, 12, 1))
    end

    it "parses MM/DD/YYYY..MM/DD/YYYY as a date range" do
      setting = described_class.new(key: :period, item: "01/01/2025..12/01/2025")
      expect(setting.item).to eq(Date.new(2025, 1, 1)..Date.new(2025, 12, 1))
    end

    it "returns nil for non-date ranges" do
      setting = described_class.new(key: :period, item: "1..10")
      expect(setting.item).to eq("1..10")
    end

    it "returns a Range<Date> as-is" do
      range = Date.new(2025, 1, 1)..Date.new(2025, 12, 1)
      setting = described_class.new(key: :period, item: range)
      expect(setting.item).to eq(range)
    end

    it "returns non-range, non-date string as-is" do
      setting = described_class.new(key: :period, item: "not a range")
      expect(setting.item).to eq("not a range")
    end

    it "handles strings with multiple '..' safely" do
      setting = described_class.new(key: :bad_range, item: "2025-01-01..2025-12-01..oops")
      expect(setting.item).to eq("2025-01-01..2025-12-01..oops")
    end

    it "returns original string if one side of the range is missing" do
      setting = described_class.new(key: :partial_range, item: "2025-01-01..")
      expect(setting.item).to eq("2025-01-01..")
    end

    it "returns original string if both sides are empty" do
      setting = described_class.new(key: :empty_range, item: "..")
      expect(setting.item).to eq("..")
    end

    it "parses date range with extra whitespace around range" do
      setting = described_class.new(key: :whitespace, item: " 2025-01-01 .. 2025-12-01 ")
      expect(setting.item).to eq(Date.new(2025, 1, 1)..Date.new(2025, 12, 1))
    end

    it "returns nil as-is when item is nil" do
      setting = described_class.new(key: :period, item: nil)
      expect(setting.item).to be_nil
    end

    it "returns non-string value that does not respond to include? as-is" do
      setting = described_class.new(key: :period, item: 12345)
      expect(setting.item).to eq(12345)
    end

    it "returns original string if range has more than two parts" do
      setting = described_class.new(key: :bad_range, item: "2025-01-01..2025-12-01..2025-12-31")
      expect(setting.item).to eq("2025-01-01..2025-12-01..2025-12-31")
    end
  end
end
