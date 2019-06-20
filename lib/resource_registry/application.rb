require 'dry-configurable'

module ResourceRegistry
  class Application
    extend Dry::Configurable

    setting :default_store, :mongodb

    # ResourceRegistry::Application.config.test[:default].call
    setting(:test, { one: 'val1', two: 'val2', default: -> { 6 * 7 } }) { |vals| vals }

    setting :stores do
      setting :mongodb do
        setting :collection_name, 'resource_registry_settings'
        setting :collection_name_meta do
          setting :type, :string
          setting :default, 'resource_registry_settings'
        end

      end
    end

    setting :serializers do
    end

    setting :features do
      # Entry Point: Enterprise
      setting(:ca_shop_market_feature,         { key: :aca_shop_market, title: "ACA SHOP Market", description: "ACA Small Business Health Options (SHOP) Portal" })

      # Entry Point: Routing
      setting(:aca_individual_market_feature,  { key: :aca_individual_market, title: "ACA Individual Market", description: "ACA Individual Market Portal"})

      # Entry Point: Routing
      setting(:fehb_market_feature,            { key: :fehb_market, title: "Congress and Federal Employee Market", description: "Federal Employee Health Benefits Portal"})

      # Entry Point: Routing
      setting(:ea_broker_portal_feature,       { key: :ea_broker_portal, title: "Broker Agency Portal", description: "Web portal for Broker Agencies to manage customers and their benefits" })

      # Entry Point: Routing
      setting(:ea_ga_portal_feature,           { key: :ea_ga_portal, title: "General Agency Portal", description: "Web portal for General Agencies to support Broker Agencies" })

      # Entry Point: Routing
      setting(:broker_quoting_tool_feature,    { key: :bqt_portal, title: "Broker Quoting Tool", description: "" })

      # Entry Point: Routing
      setting(:ea_ops_portal_feature,          { key: :ea_ops_portal, title: "Business Operations Portal", description: "Web portal for site business staff to manage site customers stakeholders and operations" })

      # Entry Point: Routing
      setting(:ea_ops_classic_portal_feature,  { key: :ea_ops_classic_portal, title: "Business Operations Portal (classic)", description: "Web portal for site business staff to manage site products, customers, stakeholders and operations" })

      # Entry Point: Routing
      setting(:ea_plan_mgt_portal_feature,     { key: :ea_plan_mgt_portal, title: "Plan Management Portal", description: "Web portal for site plan management staff to manage benefit products" })

      # Entry Point: Enterprise
      setting(:enterprise_admin_portal_component,        { key: :enterprise_admin_portal, title: "Web portal for IT staff to configure and administer the site system and services", description: "" })

      # Entry Point: Enterprise
      setting(:ea_component,                   { key: :ea_component, title: "Enroll Application Component", description: "" })

      # Entry Point: Enterprise
      setting(:edi_db_classic_component,       { key: :edi_db_classic_component, title: "EDI Database Component (classic)", description: "" })

      # Entry Point: Enterprise
      setting(:edi_db_component,               { key: :edi_db_component, title: "EDI Database Component", description: "" })

      # Entry Point: Enterprise
      setting(:ledger_component,               { key: :ledger_component, title: "Ledger Component", description: "Web portal for accounts, billing and payment" })

      # Entry Point: Enterprise
      setting(:notice_component,               { key: :notice_component, title: "Notice Component", description: "" })

      # Entry Point: Enterprise
      setting(:trans_gw_component,             { key: :trans_gw_component, title: "Transport Gateway Component", description: "" })
    end



  end
end
