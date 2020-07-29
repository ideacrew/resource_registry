# frozen_string_literal: true

require 'dry-types'
require 'active_support'
require 'active_support/core_ext'

module Types
  send(:include, Dry.Types())
  include Dry::Logic

  Uri               = Types.Constructor(::URI) { |val| (val.is_a? URI) ? val : ::URI.parse(val) }
  Url               = Uri

  Environment       = Types::Coercible::Symbol.default(:production).enum(:development, :test, :production)
  Serializers       = Types::String.default('yaml_serializer').enum('yaml_serializer', 'xml_serializer')
  Stores            = Types::String.default('file_store').enum('file_store')

  CallableDate      = Types::Date.default { Date.today }
  CallableDateTime  = Types::DateTime.default { DateTime.now }

  RequiredSymbol    = Types::Strict::Symbol
  RequiredString    = Types::Strict::String.constrained(min_size: 1)

  HashOrNil         = Types::Hash | Types::Nil
  StringOrNil       = Types::String | Types::Nil


  Email             = String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)

  EmailOrString     = Types::Email | Types::String
  SymbolOrString    = Types::Symbol | Types::String
  NilOrString       = Types::Nil | Types::String

  StrictSymbolizingHash = Types::Hash.schema({}).strict.with_key_transform(&:to_sym)

  Callable = Types.Interface(:call)

  StrippedString  = String.constructor(&:strip)
  Duration        = Types.Constructor(ActiveSupport::Duration) {|val| parts = val.shift; ActiveSupport::Duration.send(parts[0], parts[1]) }

  Path            = Types.Constructor(Pathname) {|val| val.is_a?(Pathname) ? val : Pathname.new(val) }

  TypeContainer = Dry::Schema::TypeContainer.new
  TypeContainer.register('params.stripped_string', StrippedString)
  TypeContainer.register('params.duration', Duration)
  TypeContainer.register('params.path', Path)
  # Dry::Schema::Params.config.types << TypeContainer
end
