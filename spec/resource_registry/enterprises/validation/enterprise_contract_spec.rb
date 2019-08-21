# frozen_string_literal: true

require 'spec_helper'
require 'resource_registry/enterprises/validation/enterprise_contract'

RSpec.describe ResourceRegistry::Enterprises::Validation::EnterpriseContract do

  let(:owner_organization_name) { "owner_organization_name attribute value" }
  let(:owner_account_name)      { "owner_account_name attribute value" }

  let(:optional_params)         {
    { owner_organization_name: owner_organization_name,
      owner_account_name: owner_account_name,}
  }

  let(:all_params)              { optional_params }

  describe 'EnterpriseContract parameters' do

    context "with no parameters" do
      it { expect(subject.call({}).success?).to be_truthy }
      it { expect(subject.call({}).errors.messages).to eq [] }
    end

    context "with all Enterprise params" do
      it { expect(subject.call(all_params).success?).to be_truthy }
      it { expect(subject.call(all_params).errors.messages).to eq [] }
    end

    describe "Tenant parameters" do
      let(:nested_tenants)                { { tenants: [{ key: :tenant_key_1 }, { key: :tenant_key_2 }] } }

      context "with no Enterprise and only Tenants params" do
        it { expect(subject.call(nested_tenants).success?).to be_truthy }
        it { expect(subject.call(nested_tenants).errors.messages).to eq [] }
      end

      context "with all Enterprise params and valid nested Tenant params" do
        let(:all_params_and_nested_tenants) { all_params.merge(nested_tenants) }

        it { expect(subject.call(all_params_and_nested_tenants).success?).to be_truthy }
        it { expect(subject.call(all_params_and_nested_tenants).errors.messages).to eq [] }
        it { expect(subject.call(all_params_and_nested_tenants).to_h).to eq all_params_and_nested_tenants }
      end

      context "with all Enterprise params and invalid nested Tenant params" do
        let(:nested_invalid_tenants)                { { tenants: [{ owner_account_name: "mary@example.com" }] } }
        let(:all_params_and_nested_invalid_tenants) { all_params.merge(nested_invalid_tenants) }

        it { expect(subject.call(all_params_and_nested_invalid_tenants).success?).to be_falsey }
        it { expect(subject.call(all_params_and_nested_invalid_tenants).errors.first.path).to include(:tenants) }
        it { expect(subject.call(all_params_and_nested_invalid_tenants).errors.first.text).to start_with "validation failed: [{:key=>[{:path=>\"[:key]\"}" }
      end
    end
  end
end