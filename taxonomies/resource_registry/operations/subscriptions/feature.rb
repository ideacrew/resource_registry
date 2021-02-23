# frozen_string_literal: true

module ResourceRegistry
  module Subscriptions
    class Feature
      # include Mongoid::Document
      # include Mongoid::Timestamps


      FEATURES = {
        # Entry Point: Routing
        aca_shop_market_feature: { key: :aca_shop_market,
                                   title: "ACA SHOP Market",
                                   description: "ACA Small Business Health Options (SHOP) Portal" },

        # Entry Point: Routing
        aca_individual_market_feature: { key: :aca_individual_market,
                                         title: "ACA Individual Market",
                                         description: "ACA Individual Market Portal"},

        # Entry Point: Routing
        fehb_market_feature: { key: :fehb_market,
                               title: "Congress and Federal Employee Market",
                               description: "Federal Employee Health Benefits Portal"},

        # Entry Point: Routing
        ea_broker_portal_feature: { key: :ea_broker_portal,
                                    title: "Broker Agency Portal",
                                    description: "Web portal for Broker Agencies to manage customers and their benefits" },

        # Entry Point: Routing
        ea_ga_portal_feature: { key: :ea_ga_portal,
                                title: "General Agency Portal",
                                description: "Web portal for General Agencies to support Broker Agencies" },

        # Entry Point: Routing
        broker_quoting_tool_feature: { key: :bqt_portal,
                                       title: "Broker Quoting Tool",
                                       description: "" },

        # Entry Point: Routing
        ea_ops_portal_feature: { key: :ea_ops_portal,
                                 title: "Business Operations Portal",
                                 description: "Web portal for site business staff to manage site customers stakeholders and operations" },

        # Entry Point: Routing
        ea_ops_classic_portal_feature: { key: :ea_ops_classic_portal,
                                         title: "Business Operations Portal (classic)",
                                         description: "Web portal for site business staff to manage site products, customers, stakeholders and operations" },

        # Entry Point: Routing
        ea_plan_mgt_portal_feature: { key: :ea_plan_mgt_portal,
                                      title: "Plan Management Portal",
                                      description: "Web portal for site plan management staff to manage benefit products" },

        # Entry Point: Enterprise
        enterprise_admin_portal: { key: :enterprise_admin_portal,
                                   title: "Web portal for IT staff to configure and administer the site system and services",
                                   description: "" },

        # Entry Point: Enterprise
        ea_component: { key: :ea_component,
                        title: "Enroll Application Component",
                        description: "" },

        # Entry Point: Enterprise
        edi_db_classic_component: { key: :edi_db_classic_component,
                                    title: "EDI Database Component (classic)",
                                    description: "" },
        # Entry Point: Enterprise
        edi_db_component: { key: :edi_db_component,
                            title: "EDI Database Component",
                            description: "" },

        # Entry Point: Enterprise
        ledger_component: { key: :ledger_component,
                            title: "Ledger Component",
                            description: "Web portal for accounts, billing and payment" },

        # Entry Point: Enterprise
        notice_component: { key: :notice_component,
                            title: "Notice Component",
                            description: "" },

        # Entry Point: Enterprise
        trans_gw_component: { key: :trans_gw_component,
                              title: "Transport Gateway Component",
                              description: "" }
      }.freeze

      # has_many  :subscriptions,
      #   class_name: 'Subscriptions::Subscription'

      # field :key,         type: Symbol
      # field :title,       type: String
      # field :description, type: String


      # validates_presence_of :key, :title, :description

      # index({ key: 1 }, { unique: true })

      def tenants
        Tenant.in(id: subscriptions.pluck(:tenant_id))
      end

    end
  end
end
