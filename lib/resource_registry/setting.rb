require 'dry-struct'

module ResourceRegistry

  class CollectionSet  < Dry::Struct
    attribute :name,  Types::Symbol
  end

  class Namespace  < Dry::Struct
    attribute :namespace?,  Types::Symbol
  end

  class Setting < Dry::Struct
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
