require 'spec_helper'
require 'resource_registry/options/validation/option_contract'

RSpec.describe ResourceRegistry::Options::Validation::OptionContract do

  let(:option_contract_key)           { :option_contract_key_symbol }

  let(:setting_key)                   { :setting_key_symbol }
  let(:setting_default)               { "setting default attribute value" }
  let(:setting_title)                 { "setting title attribute value" }
  let(:setting_description)           { "setting description value" }
  let(:setting_type)                  { :sample_type }
  let(:setting_value)                 { "setting value attribute value" }

  let(:required_settings)             { { key: setting_key, default: setting_default } }
  let(:optional_settings)             { { title: setting_title,
                                          description: setting_description, 
                                          type: setting_type, 
                                          value: setting_value, } }

  let(:all_settings)                  { [ required_settings.merge(optional_settings) ] }

  let(:namespaces_key)                    { :namespaces_key_level_0 }
  let(:required_namespaces_params)        { { key: namespaces_key, } }
  let(:all_namespaces)                    { [required_namespaces_params] }

  let(:required_namespaces_and_settings)  { { key: option_contract_key, 
                                              settings: [required_settings], 
                                              namespaces: [required_namespaces_params] } }

  let(:all_namespaces_and_settings)       { { key: option_contract_key, 
                                              settings: all_settings, 
                                              namespaces: all_namespaces } }



  describe 'OptionContract parameters' do

    context "with no parameters" do
      it { expect(subject.call({}).success?).to be_falsey }
      it { expect(subject.call({}).error?(:key)).to be_truthy }
    end

    context "with OptionContract key parameter only" do
      it { expect(subject.call({key: option_contract_key}).success?).to be_truthy }
    end

    context "with OptionContract key, required Settings params and no Namespaces params" do
      it { expect(subject.call({key: option_contract_key, settings: [required_settings]}).success?).to be_truthy }
    end

    context "with OptionContract key, optional Settings params and no Namespaces params" do
      it { expect(subject.call({key: option_contract_key, settings: [optional_settings]}).success?).to be_falsey }
    end

    context "with OptionContract key, all Settings params and no Namespaces params" do
      it { expect(subject.call({key: option_contract_key, settings: all_settings}).success?).to be_truthy }
    end

    context "with OptionContract key, no Settings params and all Namespaces params" do
      it { expect(subject.call({key: option_contract_key, namespaces: all_namespaces}).success?).to be_truthy }
    end

    context "with OptionContract key, all Settings params and valid nested Namespaces params" do
     let(:nested_namespaces)                  { [
                                                  { key: :namespace_key_1, namespaces: [{ key: :namespace_key_1_1 }] },
                                                  { key: :namespace_key_2, namespaces: [{ key: :namespace_key_2_1 }] }
                                              ] }

     let(:nested_namespaces_and_all_settings) { { key: option_contract_key, 
                                                  settings: all_settings, 
                                                  namespaces: nested_namespaces } }

      it { expect(subject.call(nested_namespaces_and_all_settings).success?).to be_truthy }
      it { expect(subject.call(nested_namespaces_and_all_settings).to_h).to include(nested_namespaces_and_all_settings) }
    end

    context "with OptionContract key, all Settings params and invalid nested Namespaces params" do
     let(:nested_invalid_namespaces)          { [
                                                  { key: :namespace_key_1, namespaces: [{ key: :namespace_key_1_1, settings: [{key: :first_setting}] }] },
                                                  { key: :namespace_key_2, settings: [{key: :second_setting}], namespaces: [{ key: :namespace_key_2_1 }] }
                                              ] }

     let(:nested_namespaces_and_all_settings) { { key: option_contract_key, 
                                                  settings: all_settings, 
                                                  namespaces: nested_invalid_namespaces } }

      it { expect(subject.call(nested_namespaces_and_all_settings).success?).to be_falsey }
      it { expect(subject.call(nested_namespaces_and_all_settings).errors.first.path).to include(:namespaces) }
      it { expect(subject.call(nested_namespaces_and_all_settings).errors.first.text).to start_with "validation failed: [{:\"namespaces.0\"=>[{:path=>\"[:namespaces, 0]\"}" }
    end

    context "with OptionContract key, all valid Setting and Namespaces params, plus an undefined param" do
      let(:undefined_param_key)   { :undefined_param_key }
      let(:undefined_param_value) { "this param doesn't exist in contract" }
      let(:undefined_param_hash)  { { undefined_param_key: undefined_param_value } }

      # it { expect(subject.call(all_namespaces_and_settings.merge(undefined_param_hash)).success?).to be_falsey }
      # it { expect(subject.call(all_namespaces_and_settings.merge(undefined_param_hash)).error?(:key)).to be_truthy }
      # it { expect(subject.call(all_namespaces_and_settings.merge(undefined_param_hash)).errors.to_h).to be_nil }
    end
  end
end