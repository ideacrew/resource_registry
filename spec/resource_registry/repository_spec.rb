require "spec_helper"
require 'dry/container/stub'

RSpec.describe ResourceRegistry::Repository do

  describe "Instantiating a repository" do
    subject { described_class.new  }

    it { expect(subject.config.registry).to be_a(Dry::Container::Registry) }
    it "top_namespace should be nil" do
      expect(subject.top_namespace).to be_nil
    end

    context "class method #namespace_join" do
      context "is passed an empty array" do
        let(:empty_array) { [] }
        let(:joined_namespaces)   { nil }

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

    context "instance method #add_namespace" do
      let(:new_namespace)     { :new_namespace }
      let(:new_namespace_str) { new_namespace.to_s }

      it { expect(subject.add_namespace(new_namespace)).to be_a(Dry::Container::Namespace)   }
      it { expect(subject.add_namespace(new_namespace).name).to eq new_namespace_str }
    end

    context "with a top namespace" do
      let(:top_namespace)     { :dchbx }
      let(:top_namespace_str) { top_namespace.to_s }

      subject { described_class.new(top_namespace: top_namespace) }
      it { expect(subject.top_namespace).to eq top_namespace_str }
    
      context "and an item is registered in the repository" do
        let(:logfile_key)   { :logfile_name}
        let(:logfile_value) { "logfile.log" }
        let(:qualified_logfile_key)  { top_namespace.to_s + '.' + logfile_key.to_s }

        before do
          namespace_str = subject.class.namespace_join([top_namespace, logfile_key])
          subject.register(namespace_str) { logfile_value }
        end

        it "the item should be found in the namespace prepended by the namespace root" do
          expect(subject.resolve(qualified_logfile_key)).to eq logfile_value
        end
      end

      context "instance method #add_namespace" do
        let(:new_namespace)   { :new_namespace }
        let(:full_namespace)  { top_namespace.to_s + '.' + new_namespace.to_s }

        it { expect(subject.add_namespace(new_namespace)).to be_a(Dry::Container::Namespace)   }
        it { expect(subject.add_namespace(new_namespace).name).to eq full_namespace }
      end
    end
  end

  describe "and entries are added" do

    subject { described_class.new  }

    before do

      subject.register('')

      subject.register('note_storage', -> { NoteTextStorage.new })
      AutoInject = Dry::AutoInject(dependency_container)
    end



    let(:ea_app_feature)          { { key: :benefit_markets, 
                                      title: "Benefit Markets", 
                                      description: "Defined marketplaces, processes and rules",
                                      option_group_keys: [:aca_shop_market, :aca_individual_market, :fehb_market] 
                                      } }



    let(:application_keys)        { [ea_application[:key], edi_database[:key]] }

    let(:dc_ea_app_feature_keys)  { [ea_app_feature.option_group_keys[0], ea_app_feature.option_group_keys[1], ea_app_feature.option_group_keys[2]] }
    let(:cca_ea_app_feature_keys) { [ea_app_feature.option_group_keys[0]] }

    let(:dc_tenant)               { { key: :dchbx, title: "DC HealthLink", application_subscription_keys: application_keys } }
    let(:cca_tenant)              { { key: :cca, title: "Massachusettes Health Connector", application_subscription_keys: application_keys } }

    let(:site)                    { { key: :shared_host, 
                                      title: "Multitenant shared environment", 
                                      applications: applications, 
                                      tenants: [dc_tenant, cca_tenant],
                                      } }

    it "should" do

    end


  end

  describe "and namespaces and values are added" do

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

