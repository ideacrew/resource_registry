# frozen_string_literal: true

require 'dry-types'
require 'active_support'
require 'active_support/core_ext'
# Dry::Types.load_extensions(:maybe)

module Types
  include Dry.Types()
  include Dry::Logic

  Environment     = Types::Coercible::Symbol.default(:production).enum(:development, :test, :production)
  Serializers     = Types::String.default('yaml_serializer'.freeze).enum('yaml_serializer', 'xml_serializer')
  Stores          = Types::String.default('file_store'.freeze).enum('file_store')

  CallableDate      = Types::Date.default { Date.today }
  CallableDateTime  = Types::DateTime.default { DateTime.now }

  RequiredSymbol  = Types::Strict::Symbol.constrained(min_size: 2)
  RequiredString  = Types::Strict::String.constrained(min_size: 1)

  HashOrNil       = Types::Hash | Types::Nil
  StringOrNil     = Types::String | Types::Nil

  StrippedString  = String.constructor(->(val){ String(val).strip })
  Email           = String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)

  EmailOrString   = Types::Email | Types::String
  SymbolOrString  = Types::Symbol | Types::String
  NilOrString     = Types::Nil | Types::String

  Callable   = Types.Interface(:call)

  Duration   = Types.Constructor(ActiveSupport::Duration) {|val| ActiveSupport::Duration.build(val) }
  Path       = Types.Constructor(Pathname) {|val| val.is_a?(Pathname) ? val : Pathname.new(val) }


  # def self.duration_for(duration_hash = {})
  #   span_kinds = [:years, :months, :weeks, :days, :hours, :minutes, :seconds]
  #   size = duration_hash.first[1]
  #   span = duration_hash.first[0].to_sym

  #   raise ArgumentError, "invalid key: #{span}" unless span_kinds.include?(span)
  #   raise ArgumentError, "invalid value: #{size}" unless size.is_a?(Integer)

  #   size.to_i.send(span)
  # end

  # Expects input formatted as: { days: 60 }, { months: 6 }
  # Duration = Hash.with_type_transform do |key|
  #   key = key.to_sym
  #   unless [:years, :months, :weeks, :days, :hours, :minutes, :seconds].includes? key
  #     raise Dry::Types::UnknownKeysError, "unexpected key [#{key}] in Hash input"
  #   end
  # end.with_type_transform { |type| type.required(false) }.schema(length: Integer)
end
