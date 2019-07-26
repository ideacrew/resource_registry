# nested configuration settings file called from load_settings.rb

Repo.namespace(:features) do
  # Entry Point: Enterprise
  register(:aca_shop_market_feature,        { 
                                              type: :symbol,
                                              default: :aca_shop_market, 
                                              value: :aca_shop_market, 
                                              title: "ACA SHOP Market", 
                                              description: "ACA Small Business Health Options (SHOP) Portal" 
                                            })

  # Entry Point: Routing
  register(:aca_individual_market_feature,  { 
                                              type: :symbol,
                                              default: :aca_individual_market, 
                                              value: :aca_individual_market, 
                                              title: "ACA Individual Market", 
                                              description: "ACA Individual Market Portal"
                                            })

  # Entry Point: Routing
  register(:fehb_market_feature,            { 
                                              type: :symbol,
                                              default: :fehb_market, 
                                              value: :fehb_market, 
                                              title: "Congress and Federal Employee Market", 
                                              description: "Federal Employee Health Benefits Portal"
                                            })

  # Entry Point: Routing
  register(:ea_broker_portal_feature,       { 
                                              type: :symbol,
                                              default: :ea_broker_portal, 
                                              value: :ea_broker_portal, 
                                              title: "Broker Agency Portal", 
                                              description: "Web portal for Broker Agencies to manage customers and their benefits" 
                                            })

  # Entry Point: Routing
  register(:ea_ga_portal_feature,           { 
                                              type: :symbol,
                                              default: :ea_ga_portal, 
                                              value: :ea_ga_portal, 
                                              title: "General Agency Portal", 
                                              description: "Web portal for General Agencies to support Broker Agencies" 
                                            })

  # Entry Point: Routing
  register(:broker_quoting_tool_feature,    { 
                                              type: :symbol,
                                              default: :bqt_portal, 
                                              value: :bqt_portal, 
                                              title: "Broker Quoting Tool", 
                                              description: "" 
                                            })

  # Entry Point: Routing
  register(:ea_ops_portal_feature,          { 
                                              type: :symbol,
                                              default: :ea_ops_portal, 
                                              value: :ea_ops_portal, 
                                              title: "Business Operations Portal", 
                                              description: "Web portal for site business staff to manage site customers stakeholders and operations" 
                                            })

  # Entry Point: Routing
  register(:ea_ops_classic_portal_feature,  { 
                                              type: :symbol,
                                              default: :ea_ops_classic_portal, 
                                              value: :ea_ops_classic_portal, 
                                              title: "Business Operations Portal (classic)", 
                                              description: "Web portal for site business staff to manage site products, customers, stakeholders and operations" 
                                            })

  # Entry Point: Routing
  register(:ea_plan_mgt_portal_feature,     { 
                                              type: :symbol,
                                              default: :ea_plan_mgt_portal, 
                                              value: :ea_plan_mgt_portal, 
                                              title: "Plan Management Portal", 
                                              description: "Web portal for site plan management staff to manage benefit products" 
                                            })
end
