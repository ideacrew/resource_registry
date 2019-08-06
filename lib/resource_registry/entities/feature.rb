module ResourceRegistry
  module Entities
    class Feature
      extend Dry::Initializer

        option :key          
        option :is_required
        option :alt_key,        optional: true
        option :title,          optional: true
        option :description,    optional: true
        option :parent,         optional: true


        option :environments, [], optional: true do
          # option :environment, type: ResourceRegistry::Types::Array.of(ResourceRegistry::Types::Environments) do
          option :environment, [], optional: true do
            option :is_enabled
            option :registry,   optional: true #,   type: Dry::Types::Array.of(RegistryConstructor), optional: true
            option :options,    optional: true #,   type: Dry::Types::Array.of(OptionConstructor), optional: true
            option :features,   optional: true #,   type: Dry::Types::Array.of(FeatureConstructor), optional: true
          end
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
