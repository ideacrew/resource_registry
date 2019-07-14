module ResourceRegistry
  module Options
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
  end
end