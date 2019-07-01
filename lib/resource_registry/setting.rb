require 'dry-struct'

module ResourceRegistry
  class Setting < Dry::Struct
    transform_keys(&:to_sym)

    # Collection set will often resolve to an independent system component
    # Setting identifier must be unique for each :namespace/:key combination
    attribute :collection_set_name, Types::Symbol
    attribute :namespace?,          Types::Symbol
    attribute :key,                 Types::Symbol

    attribute :meta do
      attribute :title,             Types::Strict::String
      attribute :description,       Types::Strict::String
      attribute :type,              Types::Symbol
      attribute :default,           Types::Coercible::String
      attribute :value,             Types::Coercible::String
    end

  end
end
