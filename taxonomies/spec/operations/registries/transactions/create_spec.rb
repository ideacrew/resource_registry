# frozen_string_literal: true

require 'spec_helper'
require 'support/initialize_registry'

RSpec.describe ResourceRegistry::Registries::Transactions::Create do
  include RegistryDataSeed

  context "when valid input passed" do

    before(:all) do
      reset_registry
      initialize_registry
    end

    after do
      reset_registry
    end

    it "should load configuration and settings" do
      described_class.new.call(configuration_file_path)

      configuration_options_hash[:resource_registry][:config].each_pair do |key, value|
        test_value = (key == :root) ? Pathname.new(value) : value
        expect(Registry["resource_registry.config.#{key}"]).to eq test_value if test_value.present?
      end

      expect(Registry.keys.include?("enterprise.dchbx.shop_site.production.copyright_period_start")).to be_truthy
      expect(Registry.keys.include?("enterprise.dchbx.shop_site.production.policies_url")).to be_truthy
      expect(Registry.keys.any?{|key| key.scan(/enterprise.dchbx.shop_site.production.enroll_app.aca_shop_market.small_market_employee_count_maximum/).present?}).to be_truthy
    end
  end
end
