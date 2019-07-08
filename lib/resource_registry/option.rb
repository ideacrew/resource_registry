require 'dry-struct'

module ResourceRegistry
  module Options

    class Tenant < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key, Types::Symbol
      attribute :application_subscription_keys, Types::Array
    end

    # An Application is all code operating under a single process
    class Application < Dry::Struct # EA, EDI DB, Ledger
      transform_keys(&:to_sym)

      attribute :key,             Types::Symbol
      attribute :title?,          Types::Strict::String
      attribute :description?,    Types::Strict::String
      attribute :dependency_keys, Types::Array
      attribute :feature_keys,    Types::Array

      attribute :container_key,   Types::Symbol

      attribute :tenant_application_subscription_keys, Types::Array
      attribute :option_group_keys, Types::Array
    end

    class Site < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,               Types::Symbol
      attribute :title?,            Types::Strict::String
      attribute :applications,      Types::Array.of(Options::Application)
      attribute :tenants,           Types::Array.of(Options::Tenant)
    end

    class TenantApplicationSubscription < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,                       Types::Symbol
      attribute :tenant_key,                Types::Symbol
      attribute :application_key,           Types::Symbol
      attribute :subscription_code?,        Types::Strict::String
    end

    class Component < Dry::Struct # TransportGW, Notice Engine in independent process
    end

    class Feature  < Dry::Struct # FEHB, SHOP, IVL, GA
      transform_keys(&:to_sym)

      attribute :key,                 Types::Symbol
      attribute :title?,              Types::Strict::String
      attribute :description?,        Types::Strict::String
      attribute :option_group_keys, Types::Array
    end

    class OptionsGroup  < Dry::Struct # ER Attestation, Newly-designated
      transform_keys(&:to_sym)

      attribute :key,             Types::Symbol
      attribute :option,        Types::String
      attribute :option_group_keys,  Types::Array

      def to_Entrie
      end
    end

    class Option < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,           Types::Symbol
      attribute :title?,        Types::Strict::String
      attribute :description?,  Types::Strict::String
      attribute :type,          Types::Symbol
      # attribute :default,       Types::Item
      # attribute :value,         Types::Item
      attribute :meta,          Types::Hash
    end

    class Item < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key, Types::Symbol
      attribute :value, Types::String
      attribute :options, Types::String # call
    end

    class QleOption < Dry::Struct
      transform_keys(&:to_sym)

      attribute :key,                     Types::Symbol
      attribute :tool_tip,                Types::Strict::String
      attribute :action_kind,             Types::Strict::String
      attribute :market_kind,             Types::Strict::String
      attribute :event_kind_label,        Types::Strict::String
      attribute :reason,                  Types::Strict::String
      attribute :edi_code,                Types::Strict::String
      attribute :ordinal_position,        Types::Integer
      attribute :effective_on_kinds,      Types::Array
      attribute :pre_event_sep_in_days,   Types::Integer
      attribute :post_event_sep_in_days,  Types::Integer
      attribute :is_self_attested,        Types::Integer
      attribute :date_options_available,  Types::Integer

    end


    class OldOption  < Dry::Struct 
      transform_keys(&:to_sym)

      # Collection set will often resolve to an independent system component
      # Entrie identifier must be unique for each :namespace/:key combination
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
end
