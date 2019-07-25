module ResourceRegistry
  module Entities
    # An Application is all code operating under a single process
    class QualifyingLifeEvent < Setting # EA, EDI DB, Ledger

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

      # attribute :container_key,   Types::Symbol
      # attribute :tenant_application_subscription_keys, Types::Array
      # attribute :option_group_keys, Types::Array
      # attribute :dependency_keys?,  Types::Array

      def to_container
        container = Dry::Container::new
        container.namespace(key) do |namespace|
          load_collection features, namespace
          load_collection namespaces, namespace
          load_collection options, namespace
        end
        container
      end
    end
  end
end