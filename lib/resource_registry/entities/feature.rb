module ResourceRegistry
  module Entities
    class Feature < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,         Types::RequiredSymbol
      attribute :title,       Types::String.optional
      attribute :description, Types::String.optional
      attribute :parent,      Types::String.optional

      attribute :environments do
        attribute :key,         Types::Environments
        attribute :enabled,     Types::Bool.default(false)
        # attribute :registry,    ResourceRegistry::Entities::Registry.optional
        # attribute :options,     ResourceRegistry::Entities::Option.optional
      end
    end
  end
end

  # FEATURES = {
  #   aca_shop_market:        { title: "ACA SHOP Market", description: "ACA Small Business Health Options (SHOP) State Based Exchange" },
  #   aca_individual_market:  { title: "ACA Individual Market", description: "ACA Individual Market State Based Exchange"},
  #   broker_agency_portal:   { title: "Broker Agency Portal", description: "Dedicated Web portal for Broker Agencies to register and manage their customer accounts" },
  #   general_agency_portal:  { title: "General Agency Portal", description: "Dedicated Web portal for General Agencies to Register and support their Broker Agency accounts" },
  #   broker_quoting_tool:    { title: "Broker Quoting Tool", description: "" },
  #   notice_engine:          { title: "", description: "" },
  #   admin_ui_classic:       { title: "", description: "" },
  #   admin_ui_modern:        { title: "", description: "" },
  # }
