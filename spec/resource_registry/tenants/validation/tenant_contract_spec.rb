# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Tenants::Validation::TenantContract do

  describe "Tenant core parameters" do
    let(:key)                     { :dchbx }
    let(:owner_organization_name) { 'District of Columbia Health Benefit Exchange Authority' }
    let(:owner_account_name)      { 'mk@example.com' }

    let(:required_params)         { { key: key } }
    let(:optional_params)         { { owner_organization_name: owner_organization_name, owner_account_name: owner_account_name } }
    let(:all_core_params)         { required_params.merge(optional_params) }

    let(:key_coercion_params) { {key: key.to_s } }

    context "with invalid parameters" do
      let(:error_key) { :key }

      context "with no parameters" do
        it { expect(subject.call({}).success?).to be_falsey }
        it { expect(subject.call({}).error?(error_key)).to be_truthy }
      end

      context "with optional parameters only" do
        it { expect(subject.call(optional_params).success?).to be_falsey }
        it { expect(subject.call(optional_params).error?(error_key)).to be_truthy }
      end
    end

    context "with valid parameters" do
      let(:required_key)  { :key }
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
          expect(result[required_key]).to eq key
        end
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
          subscribed_on: subscribed_on
        }
      end

      context "with all core parameters and optional Subscriptions params" do
        let(:wrapped_subscriptions_params)  { { subscriptions: [all_subscriptions_params] } }
        let(:core_and_subscriptions_params) { all_core_params.merge(wrapped_subscriptions_params) }

        it { expect(subject.call(core_and_subscriptions_params).success?).to be_truthy }
        it { expect(subject.call(core_and_subscriptions_params).to_h).to eq core_and_subscriptions_params }

      end
    end

    describe "Site parameters" do
      let(:site_key)      { :primary }
      let(:environments)  { [{ key: :production }] }
      let(:url)           { "http://ivl.hbx_guru.org" }
      let(:title)         { "title_value" }
      let(:description)   { "description_value" }
      let(:options)       { [] }

      let(:required_sites_params) { { key: site_key } }

      let(:all_sites_params)  do
        {
          key: site_key,
          url: url,
          title: title,
          description: description,
          options: options,
          environments: environments
        }
      end

      context "with all core parameters and only required Site params" do
        let(:wrapped_required_sites_params)  { { sites: [all_sites_params] } }
        let(:core_and_required_sites_params) { all_core_params.merge(wrapped_required_sites_params) }

        # it { expect(subject.call(core_and_required_sites_params).success?).to be_truthy }
        # it { expect(subject.call(core_and_required_sites_params).to_h).to eq core_and_required_sites_params }

        context "with all core parameters and defaulted Site param" do
          # let(:defaulted_sites_param)           { required_sites_params.except(:key) }
          let(:defaulted_sites_params) { { key: site_key, environments: [] } }
          let(:wrapped_defaulted_sites_params)  { { sites: [defaulted_sites_params] } }
          let(:core_and_defaulted_sites_params) { core_and_required_sites_params.merge(wrapped_defaulted_sites_params) }

          it { expect(subject.call(core_and_defaulted_sites_params).success?).to be_truthy }
          it { expect(subject.call(core_and_defaulted_sites_params).errors.messages).to be_empty }
        end

        context "with all core parameters and invalid defaulted Site param" do
          let(:invalid_param)                 { { environments: [{key: :bad_environment}] } }
          let(:wrapped_invalid_sites_params)  { { sites: [all_sites_params.merge(invalid_param)] } }
          let(:core_and_invalid_sites_params) { core_and_required_sites_params.merge(wrapped_invalid_sites_params) }
          let(:environment_key_error)         { "must be one of: development, test, production" }

          it { expect(subject.call(core_and_invalid_sites_params).success?).to be_falsey }
          it { expect(subject.call(core_and_invalid_sites_params).errors.messages.first.text).to start_with environment_key_error }
        end
      end

      context "with all core parameters and all Site params" do
        let(:wrapped_sites_params)  { { sites: [all_sites_params] } }
        let(:core_and_sites_params) { all_core_params.merge(wrapped_sites_params) }

        it {expect(subject.call(core_and_sites_params).success?).to be_truthy }
        it { expect(subject.call(core_and_sites_params).errors.messages).to eq [] }
        it { expect(subject.call(core_and_sites_params).to_h).to eq core_and_sites_params }

        describe "Feature parameters" do
          context "with required, valid Feature params" do
            let(:feature_key)                       { :shiney_feature }
            let(:feature_parent_key)                { :shiney_feature_parent }
            let(:is_required)                       { true }
            let(:is_enabled)                        { true }

            let(:feature_required_params)           { { key: feature_key, feature_parent_key: feature_parent_key, is_required: is_required, is_enabled: is_enabled } }
            let(:wrapped_feature_params)            { { features: [feature_required_params] } }
            let(:wrapped_environment_and_feature_params)  { { environments: [{ key: :production }.merge(wrapped_feature_params)] } }
            let(:wrapped_site_and_feature_params)         { { sites: [all_sites_params.merge(wrapped_environment_and_feature_params)] } }
            let(:core_and_sites_and_feature_params)       { all_core_params.merge(wrapped_site_and_feature_params) }

            it "shouild pass validation" do
              result = subject.call(core_and_sites_and_feature_params)

              expect(result.success?).to be_truthy
              expect(result.errors.to_h.keys).to eq []
              expect(result.to_h).to eq core_and_sites_and_feature_params
            end
          end

          context "with required Feature params, but a bad value" do
            let(:feature_key)           { :shiney_feature }
            let(:feature_parent_key)    { :shiney_feature_parent }
            let(:is_required_bad_value) { :bad_value }

            let(:feature_bad_value_params)                    { { key: feature_key, feature_parent_key: feature_parent_key, is_required: is_required_bad_value } }
            let(:wrapped_feature_bad_value_params)            { { features: [feature_bad_value_params] } }
            let(:wrapped_environment_and_feature_bad_value_params)  { { environments: [{ key: :production }.merge(wrapped_feature_bad_value_params)] } }
            let(:wrapped_site_and_feature_bad_value_params)   { { sites: [all_sites_params.merge(wrapped_environment_and_feature_bad_value_params)] } }
            let(:core_and_sites_and_feature_bad_value_params) { all_core_params.merge(wrapped_site_and_feature_bad_value_params) }

            it { expect(subject.call(core_and_sites_and_feature_bad_value_params).success?).to be_falsey }
            it { expect(subject.call(core_and_sites_and_feature_bad_value_params).errors.first.path).to include(:sites) }
            it { expect(subject.call(core_and_sites_and_feature_bad_value_params).errors.first.text).to start_with "validation failed: [{:features=>[{:path=>[:is_required]}, {:input=>\"bad_value\"" }
          end

          context "with required Feature param missing" do
            let(:is_required)             { true }
            let(:feature_missing_params)  { { is_required: is_required  } }

            let(:wrapped_feature_missing_params)            { { features: [feature_missing_params] } }
            let(:wrapped_environment_and_feature_missing_params)  { { environments: [{ key: :production }.merge(wrapped_feature_missing_params)] } }
            let(:wrapped_site_and_feature_missing_params)   { { sites: [all_sites_params.merge(wrapped_environment_and_feature_missing_params)] } }
            let(:core_and_sites_and_feature_missing_params) { all_core_params.merge(wrapped_site_and_feature_missing_params) }

            it { expect(subject.call(core_and_sites_and_feature_missing_params).success?).to be_falsey }
            it { expect(subject.call(core_and_sites_and_feature_missing_params).errors.first.path).to include(:sites) }
            it { expect(subject.call(core_and_sites_and_feature_missing_params).errors.first.text).to start_with "validation failed: [{:features=>[{:path=>[:key]}" }
          end
        end

      end
    end
  end
end
