require 'dry-struct'


module ResourceRegistry

  class Site < Dry::Struct
    attribute :key, Types::Symbol
    attribute :applications, Types::Array
    attribute :tenants, Types::Array
  end

  class Tenant < Dry::Struct
    attribute :key, Types::Symbol
    attribute :application_subscriptions, Types::Array
  end

  class Subscription
    attribute :tenant
    attribute :application
    attribute :application_features
  end

  # Code in a single process
  class Application < Dry::Struct # EA, EDI DB
    attribute :name,          Types::Symbol
    attribute :title?,        Types::Strict::String
    attribute :description?,  Types::Strict::String
    attribute :dependencies,  Types::Array

    attribute :container_key, Types::Symbol
    attribute :features,      Types::Array

    attribute :tenant_subscriptions, Types::Array

    attribute :settings_group, Types::Array
  end

  class Component < Dry::Struct # TransportGW, Notice Engine in independent process
  end

  class Feature # FEHB, SHOP, IVL, GA
    attribute :name,            Types::Symbol
    attribute :title?,          Types::Strict::String
    attribute :description?,    Types::Strict::String
    attribute :setting_groups,  Types::Array
  end

  class Feature < Dry::Struct 
  end

  class SettingsGroup # ER Attestation, Newly-designated
    attribute :name
    attribute :settings
    attribute :settings_groups

    def to_setting
      if 
    end
  end

  class Setting 
    attribute :title?,        Types::Strict::String
    attribute :description?,  Types::Strict::String
    attribute :type,          Types::Symbol
    attribute :default,       Types::Item
    attribute :value,         Types::Item
  end

  class Item < Dry::Struct # 
    attribute :key
    attribute :value
    attribute :options # call
  end

    transform_keys(&:to_sym)

    # Collection set will often resolve to an independent system component
    # Setting identifier must be unique for each :namespace/:key combination
    attribute :collection_set_name, Types::Symbol
    attribute :namespace?,          Types::Symbol

    attribute :key,                 Types::Symbol

    attribute :meta do
      attribute :title?,        Types::Strict::String
      attribute :description?,  Types::Strict::String
      attribute :type,          Types::Symbol
      attribute :default,       Types::Coercible::String
      attribute :value,         Types::Coercible::String
      attribute :enum?,         Types::Array
    end

  end
end
