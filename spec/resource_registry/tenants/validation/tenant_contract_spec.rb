require 'spec_helper'
require 'resource_registry/tenants/validation/tenant_contract'

RSpec.describe ResourceRegistry::Tenants::Validation::TenantContract do

  describe "Tenant core parameters" do
    let(:key)                     { :dchbx }
    let(:owner_organization_name) { 'District of Columbia Health Benefit Exchange Authority' }
    let(:owner_account_name)      { 'mk@example.com' }

    let(:required_params)         { { key: key } }
    let(:optional_params)         { { owner_organization_name: owner_organization_name, owner_account_name: owner_account_name } }
    let(:all_core_params)         { required_params.merge(optional_params) }

    let(:key_coercion_params) { {key: key.to_s } }

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
      it { expect(subject.call(all_core_params).success?).to be_truthy }
      it { expect(subject.call(all_core_params).to_h).to eq all_core_params }
    end

    context "and passing in keys as strings" do
      it "should coerce all stringified keys into hashes" do
        result = subject.call(key_coercion_params).to_h
        expect(result[:key]).to eq key
      end
    end

    describe "Subscription parameters" do
      let(:subscription_key)  { :ivl }
      let(:id)                { "fd34e12076" }
      let(:validator_id)      { "112333" }
      let(:subscribed_on)     {  Date.today }

      let(:all_subscriptions_params)  do
        {
          key: subscription_key,
          id: id,
          validator_id: validator_id,
          subscribed_on: subscribed_on,
        }
      end

      context "with all core parameters and optional Subscriptions params" do
        let(:wrapped_subscriptions_params)  { { subscriptions: [all_subscriptions_params] } }
        let(:core_and_subscriptions_params) { all_core_params.merge(wrapped_subscriptions_params) }

        it {expect(subject.call(core_and_subscriptions_params).success?).to be_truthy }
        it {expect(subject.call(core_and_subscriptions_params).to_h).to eq core_and_subscriptions_params }

      end
    end

    describe "Site parameters" do
      let(:site_key)    { :ivl }
      let(:environment) { :production }
      let(:url)         { "http://ivl.hbx_guru.org" }
      let(:title)       { "title_value" }
      let(:description) { "description_value" }
      let(:features)    { [] }
      let(:options)     { [] }

      let(:required_sites_params) do
        {
          key: site_key,
          environment: environment,
        }
      end

      let(:defaulted_sites_parameters) do
        {
          key: nil,
          environment: nil,
        }
      end

      let(:all_sites_params)  do
        { 
          key: site_key,
          environment: environment,
          url: url,
          title: title,
          description: description,
          options: options,
          features: features,
          }
      end

      context "with all core parameters and only required Site params" do
        let(:wrapped_required_sites_params)  { { sites: [required_sites_params] } }
        let(:core_and_required_sites_params) { all_core_params.merge(wrapped_required_sites_params) }

        it {expect(subject.call(core_and_required_sites_params).success?).to be_truthy }
        it {expect(subject.call(core_and_required_sites_params).to_h).to eq core_and_required_sites_params }

        context "with all core parameters and defaulted Site param" do
          let(:defaulted_sites_param)           { required_sites_params.except(:key) }
          let(:wrapped_defaulted_sites_params)  { { sites: [defaulted_sites_param] } }
          let(:core_and_defaulted_sites_params) { core_and_required_sites_params.merge(wrapped_defaulted_sites_params) }

          it {expect(subject.call(core_and_defaulted_sites_params).success?).to be_truthy }
          it {expect(subject.call(core_and_defaulted_sites_params).errors).to eq "" }
        end

        context "with all core parameters and invalid required Site param" do
          let(:invalid_param)                 { { environment: :bad_environment } }
          let(:wrapped_invalid_sites_params)  { { sites: [required_sites_params.merge(invalid_param)] } }
          let(:core_and_invalid_sites_params) { core_and_required_sites_params.merge(wrapped_invalid_sites_params) }

          it {expect(subject.call(core_and_invalid_sites_params).success?).to be_falsey }
          it {expect(subject.call(core_and_invalid_sites_params).errors).to eq "" }
        end
      end

      context "with all core parameters and all Site params" do
        let(:wrapped_sites_params)  { { sites: [all_sites_params] } }
        let(:core_and_sites_params) { all_core_params.merge(wrapped_sites_params) }

        it {expect(subject.call(core_and_sites_params).success?).to be_truthy }
        it {expect(subject.call(core_and_sites_params).to_h).to eq core_and_sites_params }

        describe "Environment parameters" do
        end

        describe "Feature parameters" do
          context "with required, valid Feature params" do
            let(:feature_key)                       { :shiney_feature }
            let(:is_required)                       { true }
            let(:feature_required_params)           { { key: feature_key, is_required: is_required } }
            let(:wrapped_feature_params)            { { features: [feature_required_params] } }
            let(:wrapped_site_and_feature_params)   { { sites: [all_sites_params.merge(wrapped_feature_params)] } }
            let(:core_and_sites_and_feature_params) { all_core_params.merge(wrapped_site_and_feature_params) }

            it {expect(subject.call(core_and_sites_and_feature_params).success?).to be_truthy }
            it {expect(subject.call(core_and_sites_and_feature_params).errors.messages).to eq [] }
            it {expect(subject.call(core_and_sites_and_feature_params).to_h).to eq core_and_sites_and_feature_params }
          end

          context "with required Feature params, but a bad value" do
            let(:feature_key) { :shiney_feature }
            let(:is_required_bad_value) { "bad_value" }

            let(:feature_bad_value_params)                    { { key: feature_key, is_required: is_required_bad_value } }
            let(:wrapped_feature_bad_value_params)            { { features: [feature_bad_value_params] } }
            let(:wrapped_site_and_feature_bad_value_params)   { { sites: [all_sites_params.merge(wrapped_feature_bad_value_params)] } }
            let(:core_and_sites_and_feature_bad_value_params) { all_core_params.merge(wrapped_site_and_feature_bad_value_params) }

            it {expect(subject.call(core_and_sites_and_feature_bad_value_params).success?).to be_falsey }
            it {expect(subject.call(core_and_sites_and_feature_bad_value_params).errors.first.path).to include(:sites) }
            it {expect(subject.call(core_and_sites_and_feature_bad_value_params).errors.first.text).to start_with "validation failed: [{:path=>[:is_required]}" }
          end

          context "with required Feature param missing" do
            let(:is_required)             { true }
            let(:feature_missing_params)  { { is_required: is_required  } }

            let(:wrapped_feature_missing_params)            { { features: [feature_missing_params] } }
            let(:wrapped_site_and_feature_missing_params)   { { sites: [all_sites_params.merge(wrapped_feature_missing_params)] } }
            let(:core_and_sites_and_feature_missing_params) { all_core_params.merge(wrapped_site_and_feature_missing_params) }

            it {expect(subject.call(core_and_sites_and_feature_missing_params).success?).to be_falsey }
            it {expect(subject.call(core_and_sites_and_feature_missing_params).errors.first.path).to include(:sites) }
            it {expect(subject.call(core_and_sites_and_feature_missing_params).errors.first.text).to start_with "validation failed: [{:path=>[:key]}" }
          end
        end

      end
    end
  end
end
