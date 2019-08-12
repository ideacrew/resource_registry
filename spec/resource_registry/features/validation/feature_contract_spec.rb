require 'spec_helper'
require 'resource_registry/features/validation/feature_contract'

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

        context "with all core parameters and required environment params" do
          let(:environment_required_params)          { { is_enabled: is_enabled } }
          let(:wrapped_environment_required_params)  { { environments: [ environment_key => { is_enabled: is_enabled } ] } }
          let(:core_and_env_required_params)         { all_params.merge(wrapped_environment_required_params) }

          it {expect(subject.call(core_and_env_required_params).success?).to be_truthy }
          it {expect(subject.call(core_and_env_required_params).errors.to_h).to eq Hash.new }
          it {expect(subject.call(core_and_env_required_params).to_h).to eq core_and_env_required_params }

          context "with required, valid Registry params" do
            let(:registry_name)             { key.to_s }
            let(:registry_root)             { Pathname.pwd }
            let(:registry_required_params)  { { config: { name: registry_name, root: registry_root } } }

            let(:env_and_registry_required_params)          { environment_required_params.merge(registry: registry_required_params) }
            let(:wrapped_env_and_registry_required_params)  { { environments: [ environment_key => env_and_registry_required_params ] } }
            let(:core_and_env_and_registry_required_params) { all_params.merge(wrapped_env_and_registry_required_params) } 

            it {expect(subject.call(core_and_env_and_registry_required_params).success?).to be_truthy }
            it {expect(subject.call(core_and_env_and_registry_required_params).to_h).to eq core_and_env_and_registry_required_params }
          end

          context "with required Registy params, but a bad value" do
            let(:registry_name)             { key.to_s }
            let(:registry_root_bad_value)   { "bad/pathname/not/found" }
            let(:registry_required_params)  { { config: { name: registry_name, root: registry_root_bad_value } } }

            let(:env_and_registry_bad_value_params)           { environment_required_params.merge(registry: registry_required_params) }
            let(:wrapped_env_and_registry_bad_value_params)   { { environments: [ environment_key => env_and_registry_bad_value_params ] } }
            let(:core_and_env_and_registry_bad_value_params)  { all_params.merge(wrapped_env_and_registry_bad_value_params) } 

            it {expect(subject.call(core_and_env_and_registry_bad_value_params).success?).to be_falsey }
            it {expect(subject.call(core_and_env_and_registry_bad_value_params).errors.first.path).to include(:environments) }
            it {expect(subject.call(core_and_env_and_registry_bad_value_params).errors.first.text).to start_with "validation failed: [{:registry=>" }
            it {expect(subject.call(core_and_env_and_registry_bad_value_params).to_h).to eq core_and_env_and_registry_bad_value_params }
          end
          
          context "with required Registry param missing" do
            let(:registry_name)             { key.to_s }
            let(:registry_missing_params)   { { config: { name: registry_name } } }

            let(:env_and_registry_missing_params)           { environment_required_params.merge(registry: registry_missing_params) }
            let(:wrapped_env_and_registry_missing_params)   { { environments: [ environment_key => env_and_registry_missing_params ] } }
            let(:core_and_env_and_registry_missing_params)  { all_params.merge(wrapped_env_and_registry_missing_params) } 

            it {expect(subject.call(core_and_env_and_registry_missing_params).success?).to be_falsey }
            it {expect(subject.call(core_and_env_and_registry_missing_params).errors.first.path).to include(:environments)  }
            it {expect(subject.call(core_and_env_and_registry_missing_params).errors.first.text).to start_with "validation failed: [{:registry=>" }
            it {expect(subject.call(core_and_env_and_registry_missing_params).to_h).to eq core_and_env_and_registry_missing_params }
          end
            
        end

      end
    end
 end
end