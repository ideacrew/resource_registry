# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Setting < Dry::Struct

      attribute :key,   Types::RequiredSymbol

      # @!attribute [r] value (optional)
      # The user-assigned value for this configuratino setting.
      # @return [Any]
      attribute :value, Types::Any.optional.meta(omittable: true)

      attribute :meta,  ResourceRegistry::Entities::Meta.optional.meta(omittable: true)
    end
  end
end