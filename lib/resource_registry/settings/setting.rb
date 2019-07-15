require 'dry-struct' unless defined?(Dry::Struct)

module ResourceRegistry
  module Settings
    class Setting  < Dry::Struct
      include DryStructSetters
      transform_keys(&:to_sym)

      attribute :key,            Types::Symbol
      attribute :title?,         Types::String
      attribute :description?,   Types::String
      attribute :type?,          Types::Symbol
      attribute :default?,       Types::String
      attribute :value?,         Types::String
    end
  end
end