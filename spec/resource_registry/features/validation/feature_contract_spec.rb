require 'spec_helper'
require 'resource_registry/features/validation/feature_contract'
# require 'resource_registry/registries/validate/registry_contract'
# require 'resource_registry/options/validate/option_contract'
# require 'resource_registry/tenants/validate/tenant_contract'
# require 'resource_registry/entities'

RSpec.describe ResourceRegistry::Features::Validation::FeatureContract do

  describe "Feature core parameters" do
    let(:key)         { :feature_key_value }
    let(:is_required) { false }
    let(:alt_key)     { :alt_key_value }
    let(:title)       { "title_value" }
    let(:description) { "description_value" }
    let(:parent)      { :parent_value }

    let(:required_params)     { { key: key, is_required: is_required } }
    let(:optional_params)     { { alt_key: alt_key, title: title, description: description, parent: parent, } }
    let(:all_params)          { required_params.merge(optional_params) }
    let(:key_coercion_params) { {key: key.to_s, alt_key: alt_key.to_s, parent: parent.to_s } }

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
        expect(result[:parent]).to eq parent
      end

      describe "Feature Environments parameters" do
        let(:environment_key) { :production }
        let(:is_enabled)      { false }

        let(:nested_features) { [
                                  { key: :feature_key_1,
                                    is_required: true, 
                                    environments: [
                                      production:   [{ key: :feature_key_1_1,
                                                        is_required: false
                                                        }]
                                                     ]},
                                  { key: :feature_key_2, 
                                    environments: [
                                      production:    [{ key: :feature_key_2_1, 
                                                        is_required: false 
                                                        }] 
                                                      ]}
                              ] }


        context "with all core parameters and required environment params" do
          let(:environment_required_params)  { { is_enabled: is_enabled } }
          let(:wrapped_environment_required_params)  { { environments: [ environment_key => [ { is_enabled: is_enabled } ]] } }
          let(:core_and_env_required_params)  { all_params.merge(wrapped_environment_required_params) }

          it {expect(subject.call(core_and_env_required_params).success?).to be_truthy }
          it {expect(subject.call(core_and_env_required_params).errors.to_h).to be_nil }
          it {expect(subject.call(core_and_env_required_params).to_h).to eq core_and_env_required_params }

          context "with Registry params" do
            let(:registry_name) { key.to_s }
            let(:registry_root) { "file/path" }
            let(:registy_required_params)   { { registry: { config: { name: registry_name, root: registry_root } } } }

            let(:env_and_registry_required_params)  { environment_required_params.merge(registy_required_params) }
            let(:wrapped_env_and_registry_required_params)  { { environments: [ environment_key => [ env_and_registry_required_params ]] } }
            let(:core_and_env_and_registry_required_params) { all_params.merge(wrapped_env_and_registry_required_params) } 

            it {expect(subject.call(core_and_env_and_registry_required_params).success?).to be_truthy }
            it {expect(subject.call(core_and_env_and_registry_required_params).errors.to_h).to be_nil }
            it {expect(subject.call(core_and_env_and_registry_required_params).to_h).to eq core_and_env_and_registry_required_params }
          end
        end

      end
    end
 end


  # let(:option_contract_key)           { :option_contract_key_symbol }

  # let(:setting_key)                   { :setting_key_symbol }
  # let(:setting_default)               { "setting default attribute value" }
  # let(:setting_title)                 { "setting title attribute value" }
  # let(:setting_description)           { "setting description value" }
  # let(:setting_type)                  { "setting type attribute value" }
  # let(:setting_value)                 { "setting value attribute value" }

  # let(:required_settings)             { { key: setting_key, default: setting_default } }
  # let(:optional_settings)             { { title: setting_title,
  #                                         description: setting_description, 
  #                                         type: setting_type, 
  #                                         value: setting_value, } }

  # let(:all_settings)                  { [ required_settings.merge(optional_settings) ] }

  # let(:namespaces_key)                    { :namespaces_key_level_0 }
  # let(:required_namespaces_params)        { { key: namespaces_key, } }
  # let(:all_namespaces)                    { [required_namespaces_params] }

  # let(:required_namespaces_and_settings)  { { key: option_contract_key, 
  #                                             settings: [required_settings], 
  #                                             namespaces: [required_namespaces_params] } }

  # let(:all_namespaces_and_settings)       { { key: option_contract_key, 
  #                                             settings: all_settings, 
  #                                             namespaces: all_namespaces } }



  # describe 'OptionContract parameters' do

  #   context "with no parameters" do
  #     it { expect(subject.call({}).success?).to be_falsey }
  #     it { expect(subject.call({}).error?(:key)).to be_truthy }
  #   end

  #   context "with OptionContract key parameter only" do
  #     it { expect(subject.call({key: option_contract_key}).success?).to be_truthy }
  #   end

  #   context "with OptionContract key, required Settings params and no Namespaces params" do
  #     it { expect(subject.call({key: option_contract_key, settings: [required_settings]}).success?).to be_truthy }
  #   end

  #   context "with OptionContract key, optional Settings params and no Namespaces params" do
  #     it { expect(subject.call({key: option_contract_key, settings: [optional_settings]}).success?).to be_falsey }
  #   end

  #   context "with OptionContract key, all Settings params and no Namespaces params" do
  #     it { expect(subject.call({key: option_contract_key, settings: all_settings}).success?).to be_truthy }
  #   end

  #   context "with OptionContract key, no Settings params and all Namespaces params" do
  #     it { expect(subject.call({key: option_contract_key, namespaces: all_namespaces}).success?).to be_truthy }
  #   end

  #   context "with OptionContract key, all Settings params and nested Namespaces params" do
  #    let(:nested_namespaces)                  { [
  #                                                 { key: :namespace_key_1, namespaces: [{ key: :namespace_key_1_1 }] },
  #                                                 { key: :namespace_key_2, namespaces: [{ key: :namespace_key_2_1 }] }
  #                                             ] }

  #    let(:nested_namespaces_and_all_settings) { { key: option_contract_key, 
  #                                                 settings: all_settings, 
  #                                                 namespaces: nested_namespaces } }

  #     it { expect(subject.call(nested_namespaces_and_all_settings).success?).to be_truthy }
  #     it { expect(subject.call(nested_namespaces_and_all_settings).to_h).to eq nested_namespaces_and_all_settings }
  #   end

  #   context "with OptionContract key, all valid Setting and Namespaces params, plus an undefined param" do
  #     let(:undefined_param_key)   { :undefined_param_key }
  #     let(:undefined_param_value) { "this param doesn't exist in contract" }
  #     let(:undefined_param_hash)  { { undefined_param_key: undefined_param_value } }

  #     # it { expect(subject.call(all_namespaces_and_settings.merge(undefined_param_hash)).success?).to be_falsey }
  #     # it { expect(subject.call(all_namespaces_and_settings.merge(undefined_param_hash)).error?(:key)).to be_truthy }
  #     # it { expect(subject.call(all_namespaces_and_settings.merge(undefined_param_hash)).errors.to_h).to be_nil }
  #   end
  # end
end