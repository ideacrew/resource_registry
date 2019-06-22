require "spec_helper"
require 'dry/container/stub'

RSpec.describe ResourceRegistry::Repository do

  describe "A repository is instantiated" do
    subject { described_class.new  }

    it { expect(subject.config.registry).to be_a(Dry::Container::Registry) }
    it "namespace_root should be nil" do
      expect(subject.namespace_root).to be_nil
    end

    context "with a root namespace" do
      let(:root_name)        { :dchbx }

      subject { described_class.new(root_name: root_name) }

      it { expect(subject.namespace_root).to eq root_name }
    
      context "class method #namespace_join" do
        context "is passed an empty array" do
          let(:empty_array) { [] }
          let(:joined_namespaces)   { '' }

          it { expect(subject.class.namespace_join(empty_array)).to eq joined_namespaces}
        end

        context "is passed an array with one value" do
          let(:single_value_array)  { [:level_one] }
          let(:joined_namespaces)   { 'level_one' }

          it { expect(subject.class.namespace_join(single_value_array)).to eq joined_namespaces}
        end

        context "is passed an array with > 1 value" do
          let(:multi_value_array)   { [:level_one, :level_two] }
          let(:joined_namespaces)   { 'level_one.level_two' }

          it { expect(subject.class.namespace_join(multi_value_array)).to eq joined_namespaces}
        end
      end


      context "and an item is registered to the root namespace of the repository" do
        let(:logfile_name)  { Hash(logfile_name: "logfile.log") }
        let(:market_kinds)  { [:aca_shop, :aca_individual, :fehb, :medicaid, :medicare] }

        before { subject.register(logfile_name.keys[0]) { logfile_name.values[0] } }

        it "the item should be present" do
          expect(subject.resolve(logfile_name.keys[0])).to eq logfile_name.values[0]
        end
      end
    end


    context "and namespaces and values are added" do

    #   let(:tenant)            { "dchbx" }
    #   let(:benefit_markets)   { "benefit_markets" }
    #   let(:aca_shop_market)   { "aca_shop" }
    #   let(:fehb_market)       { "fehb" }
    #   let(:benefit_catalogs)  { "benefit_catalogs" }
    #   let(:benefit_catalog_2018)       { "benefit_catalog_2018" }
    #   let(:benefit_catalog_2019)       { "benefit_catalog_2019" }

    #   let(:shop_market)                       { [tenant, benefit_markets, aca_shop_market] }
    #   let(:shop_market_benefit_catalogs)      { [tenant, benefit_markets, aca_shop_market, benefit_catalogs] }
    #   let(:shop_market_benefit_catalogs_2018) { [tenant, benefit_markets, aca_shop_market, benefit_catalogs, benefit_catalog_2018] }
    #   let(:shop_market_benefit_catalogs_2019) { [tenant, benefit_markets, aca_shop_market, benefit_catalogs, benefit_catalog_2019] }

    #   let(:fehb_market)                       { [tenant, benefit_markets, fehb_market] }
    #   let(:fehb_market_benefit_catalogs)      { [tenant, benefit_markets, fehb_market, benefit_catalogs] }
    #   let(:fehb_market_benefit_catalogs_2018) { [tenant, benefit_markets, fehb_market, benefit_catalogs, benefit_catalog_2018] }
    #   let(:fehb_market_benefit_catalogs_2019) { [tenant, benefit_markets, fehb_market, benefit_catalogs, benefit_catalog_2019] }

    #   let(:shop_market_namespaces)            { [shop_market, shop_market_benefit_catalogs, shop_market_benefit_catalogs_2018, shop_market_benefit_catalogs_2019] }
    #   let(:fehb_market_namespaces)            { [fehb_market, fehb_market_benefit_catalogs, fehb_market_benefit_catalogs_2018, fehb_market_benefit_catalogs_2019] }

    #   let(:application_interval_kinds)        { [:monthly, :annual, :annual_with_midyear_initial] }
    #   let(:annual_application_interval)       { :annual }
    #   let(:monthly_application_interval)      { :monthly }
    #   let(:probation_period_kinds)            { [:first_of_month_before_15th, :date_of_hire, :first_of_month, :first_of_month_after_30_days, :first_of_month_after_60_days] }

    #   let(:subscription) {}

    #   before do
    #     shop_market_namespaces.each { |namespace| subject.extend_namespace(namespace) }
    #     fehb_market_namespaces.each { |namespace| subject.extend_namespace(namespace) }

    #     subject.register(described_class.namespace_join(shop_market_benefit_catalogs << "application_interval_kinds")) { application_interval_kinds }
    #     subject.register(described_class.namespace_join(shop_market_benefit_catalogs_2018 << "monthly_application_interval")) { monthly_application_interval }
    #     subject.register(described_class.namespace_join(shop_market_benefit_catalogs_2019 << "monthly_application_interval")) { monthly_application_interval }

    #     subject.register(described_class.namespace_join(fehb_market_benefit_catalogs << "application_interval_kinds")) { application_interval_kinds }
    #     subject.register(described_class.namespace_join(fehb_market_benefit_catalogs_2018 << "annual_application_interval")) { annual_application_interval }
    #     subject.register(described_class.namespace_join(fehb_market_benefit_catalogs_2019 << "annual_application_interval")) { annual_application_interval }

    #     # subject.register("#{tenant_key_str}.logfile_name") { "offtotheraces.rb" }
    #   end

    #   it "should create the nested namespaces" do
    #     expect(subject.resolve(namespace_level_2.keys.first)).to eq namespace_level_2.values.first
    #   end
    # end

    end
  end

end

