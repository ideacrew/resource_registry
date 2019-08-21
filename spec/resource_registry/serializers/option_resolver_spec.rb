require 'spec_helper'
require 'resource_registry/serializers/option_resolver'

RSpec.describe ResourceRegistry::Serializers::OptionResolver do
  include RegistryDataSeed

  context 'When valid option passed' do

    let(:full_feature_key)  { 'enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.employer_family_contribution_percent_minimum' }
    let(:short_feature_key) { 'aca_shop_market.employer_family_contribution_percent_minimum' }
    let(:site_key)          { 'enterprise.dchbx.shop_site.production.business_resource_center_url' }
    let(:wrong_site_key)    { 'business_resource_center_url' }

    before do
      initialize_registry
      ResourceRegistry.create
    end

    it "should resolve full feature key" do
      expect(Registry[full_feature_key]).to be_present
    end

    it "should resolve shortened key" do
      expect(Registry[short_feature_key]).to be_present
    end

    it "should resolve site key" do
      expect(Registry[site_key]).to be_present
    end

    it "should raise exception when wrong key passed" do
      begin
        Registry[wrong_site_key]
      rescue Dry::Container::Error => e
        expect(e.to_s).to include('Nothing registered with the key')
      end
    end
  end
end