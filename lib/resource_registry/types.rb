require 'dry-types'
require 'active_support'
require 'active_support/core_ext'
Dry::Types.load_extensions(:maybe)

module ResourceRegistry
  module Types
    include Dry::Types(default: :nominal)

    Environments    = Types::String.default('development'.freeze).enum('development', 'test', 'production')
    Serializers     = Types::String.default('yaml_serializer'.freeze).enum('yaml_serializer', 'xml_serializer')
    Stores          = Types::String.default('file_store'.freeze).enum('file_store')

    CallableDateTime = Types::DateTime.default { DateTime.now.utc }

    RequiredSymbol  = Types::Strict::Symbol.constrained(min_size: 2)
    RequiredString  = Types::Strict::String.constrained(min_size: 1)

    StrippedString  = String.constructor(->(val){ String(val).strip })
    Email           = String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)

    EmailOrString   = Types::Email | Types::String
    SymbolOrString  = Types::Symbol | Types::String
    NilOrString     = Types::Nil | Types::String

    Callable   = Types.Interface(:call)
    Duration   = Types.Constructor(:build, ->(val){ ActiveSupport::Duration.build(val) })

    def self.duration_for(duration_hash = {})
      span_kinds = [:years, :months, :weeks, :days, :hours, :minutes, :seconds]
      size  = duration_hash.first[1]
      span  = duration_hash.first[0].to_sym

      raise ArgumentError, "invalid key: #{span}" unless span_kinds.include?(span)
      raise ArgumentError, "invalid value: #{size}" unless size.is_a?(Integer)

      size.to_i.send(span)
    end

    # Expects input formatted as: { days: 60 }, { months: 6 }
    # Duration = Hash.with_type_transform do |key| 
    #   key = key.to_sym
    #   unless [:years, :months, :weeks, :days, :hours, :minutes, :seconds].includes? key
    #     raise Dry::Types::UnknownKeysError, "unexpected key [#{key}] in Hash input"
    #   end
    # end.with_type_transform { |type| type.required(false) }.schema(length: Integer)
    
  end
end