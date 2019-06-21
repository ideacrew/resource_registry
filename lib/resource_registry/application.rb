require 'dry-configurable'

module ResourceRegistry
  class Application < Repository


    register :default_store, :mongodb

    # ResourceRegistry::Application.config.test[:default].call
    register(:test, { one: 'val1', two: 'val2', default: -> { 6 * 7 } }) { |vals| vals }

    register :stores do
      register :mongodb do
        register :collection_name, 'resource_registry_registers'
      end
    end
  end

  namespace :serializers do
  end

  # Subscription Features
  # - Settings
  # - Business Rules

  namespace :features do
    # Entry Point: Enterprise
    register(:aca_shop_market_feature,        { setting: :aca_shop_market, title: "ACA SHOP Market", description: "ACA Small Business Health Options (SHOP) Portal" })

    # Entry Point: Routing
    register(:aca_individual_market_feature,  { setting: :aca_individual_market, title: "ACA Individual Market", description: "ACA Individual Market Portal"})

    # Entry Point: Routing
    register(:fehb_market_feature,            { setting: :fehb_market, title: "Congress and Federal Employee Market", description: "Federal Employee Health Benefits Portal"})

    # Entry Point: Routing
    register(:ea_broker_portal_feature,       { setting: :ea_broker_portal, title: "Broker Agency Portal", description: "Web portal for Broker Agencies to manage customers and their benefits" })

    # Entry Point: Routing
    register(:ea_ga_portal_feature,           { setting: :ea_ga_portal, title: "General Agency Portal", description: "Web portal for General Agencies to support Broker Agencies" })

    # Entry Point: Routing
    register(:broker_quoting_tool_feature,    { setting: :bqt_portal, title: "Broker Quoting Tool", description: "" })

    # Entry Point: Routing
    register(:ea_ops_portal_feature,          { setting: :ea_ops_portal, title: "Business Operations Portal", description: "Web portal for site business staff to manage site customers stakeholders and operations" })

    # Entry Point: Routing
    register(:ea_ops_classic_portal_feature,  { setting: :ea_ops_classic_portal, title: "Business Operations Portal (classic)", description: "Web portal for site business staff to manage site products, customers, stakeholders and operations" })

    # Entry Point: Routing
    register(:ea_plan_mgt_portal_feature,     { setting: :ea_plan_mgt_portal, title: "Plan Management Portal", description: "Web portal for site plan management staff to manage benefit products" })

    # Entry Point: Enterprise
    register(:enterprise_admin_portal_component,        { setting: :enterprise_admin_portal, title: "Web portal for IT staff to configure and administer the site system and services", description: "" })

    # Entry Point: Enterprise
    register(:ea_component,                   { setting: :ea_component, title: "Enroll Application Component", description: "" })

    # Entry Point: Enterprise
    register(:edi_db_classic_component,       { setting: :edi_db_classic_component, title: "EDI Database Component (classic)", description: "" })

    # Entry Point: Enterprise
    register(:edi_db_component,               { setting: :edi_db_component, title: "EDI Database Component", description: "" })

    # Entry Point: Enterprise
    register(:ledger_component,               { setting: :ledger_component, title: "Ledger Component", description: "Web portal for accounts, billing and payment" })

    # Entry Point: Enterprise
    register(:notice_component,               { setting: :notice_component, title: "Notice Component", description: "" })

    # Entry Point: Enterprise
    register(:trans_gw_component,             { setting: :trans_gw_component, title: "Transport Gateway Component", description: "" })
  end
end
