module ResourceRegistry
  module Entities
    class Setting < Dry::Struct
      include DryStructSetters
      transform_keys(&:to_sym)

      attribute :key,            Types::Symbol
      attribute :title?,         Types::String
      attribute :description?,   Types::String
      attribute :type?,          Types::Symbol
      attribute :default?,       Types::Any
      attribute :value?,         Types::Any
    
    end
  end
end