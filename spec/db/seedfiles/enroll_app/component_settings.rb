# nested configuration settings file called from load_settings.rb

Repo.namespace(:components) do
  # Entry Point: Enterprise

  register(:enterprise_admin_portal_component,  { 
                                                  type: :symbol,
                                                  default: :enterprise_admin_portal, 
                                                  value: :enterprise_admin_portal, 
                                                  title: "Web portal for IT staff to configure and administer the site system and services", 
                                                  description: "" 
                                                })

  # Entry Point: Enterprise
  register(:ea_component,                   { 
                                              type: :symbol,
                                              default: :ea_component, 
                                              value: :ea_component, 
                                              title: "Enroll Application Component", 
                                              description: "" 
                                            })

  # Entry Point: Enterprise
  register(:edi_db_classic_component,       { 
                                              type: :symbol,
                                              default: :edi_db_classic_component, 
                                              value: :edi_db_classic_component, 
                                              title: "EDI Database Component (classic)", 
                                              description: "" 
                                            })

  # Entry Point: Enterprise
  register(:edi_db_component,               { 
                                              type: :symbol,
                                              default: :edi_db_component, 
                                              value: :edi_db_component, 
                                              title: "EDI Database Component", 
                                              description: "" 
                                            })

  # Entry Point: Enterprise
  register(:ledger_component,               { 
                                              type: :symbol,
                                              default: :ledger_component, 
                                              value: :ledger_component, 
                                              title: "Ledger Component", 
                                              description: "Web portal for accounts, billing and payment" 
                                            })

  # Entry Point: Enterprise
  register(:notice_component,               { 
                                              type: :symbol,
                                              default: :notice_component, 
                                              value: :notice_component, 
                                              title: "Notice Component", 
                                              description: "" 
                                            })

  # Entry Point: Enterprise
  register(:trans_gw_component,             { 
                                              type: :symbol,
                                              default: :trans_gw_component, 
                                              value: :trans_gw_component, 
                                              title: "Transport Gateway Component", 
                                              description: "" 
                                            })
end