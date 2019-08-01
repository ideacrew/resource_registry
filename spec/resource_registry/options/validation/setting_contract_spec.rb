require 'spec_helper'
require 'resource_registry/options/validation/setting_contract'

RSpec.describe ResourceRegistry::Options::Validation::SettingContract do

  let(:key)         { :key_value }
  let(:default)     { "default attribute value" }
  let(:title)       { "title attribute value" }
  let(:description) { "description value " }
  let(:type)        { "type attribute value" }
  let(:value)       { "value attribute value" }

  let(:required_params) {
    {
      key: key,
      default: default,
    }
  }

  let(:optional_params) {
    {
      title: title,
      description: description,
      type: type,
      value: value,
    }
  }

  let(:undefined_param) { "this param doesn't exist in contract" }

  let(:all_params)  { required_params.merge(optional_params) }

  context "with only required params" do
    it "should be valid" do
      expect(subject.call(required_params).success?).to be_truthy
    end
  end

  context "with key param missing" do
    it "should be invalid" do
      expect(subject.call(all_params.except(:key)).success?).to be_falsey
      expect(subject.call(all_params.except(:key)).error?(:key)).to be_truthy
    end
  end

  context "with default param missing" do
    it "should be invalid" do
      expect(subject.call(all_params.except(:default)).success?).to be_falsey
      expect(subject.call(all_params.except(:default)).error?(:default)).to be_truthy
    end
  end

  context "with all valid params" do
    it "should be valid" do
      expect(subject.call(all_params).success?).to be_truthy
    end
  end

end