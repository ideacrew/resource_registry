# frozen_string_literal: true

require 'spec_helper'
require 'resource_registry/serializers/operations/generate_container'

RSpec.describe ResourceRegistry::Serializers::Operations::GenerateContainer do
  include RegistryDataSeed

  subject { described_class.new.call(input) }

  context 'When valid option passed' do

    let(:input) {
      options_hash.deep_symbolize_keys!
      ResourceRegistry::Entities::Option.new(options_hash)
    }

    let(:expected_keys) {
      [
       "enterprise.tenants.dchbx.sites.shop_site.url",
       "enterprise.tenants.dchbx.sites.shop_site.description",
       "enterprise.tenants.dchbx.sites.individual_site.url",
       "enterprise.tenants.dchbx.owner_account_name",
       "enterprise.tenants.dchbx.sites.shop_site.environments.production.features.enroll_app.features.aca_shop_market.options.employer_contribution_percent_minimum",
       "enterprise.tenants.dchbx.sites.shop_site.environments.production.features.enroll_app.features.aca_shop_market.options.employer_dental_contribution_percent_minimumt",
       "enterprise.tenants.dchbx.sites.shop_site.environments.production.features.enroll_app.features.aca_shop_market.options.employer_family_contribution_percent_minimum"
      ]
    }

    it "should return success with container object" do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to be_a Dry::Container
    end

    it "should have keys registered" do
      result = subject.value!

      expected_keys.each do |key|
        expect(result.keys).to include(key)
      end
    end
  end
end
