# frozen_string_literal: true

module ResourceRegistry
  class Setting < Dry::Struct

    attribute :key,   Types::RequiredSymbol

    # @!attribute [r] value (optional)
    # The user-assigned value for this configuratino setting.
    # @return [Any]
    attribute :value, Types::Any.meta(omittable: false)

    attribute :meta,  ResourceRegistry::Meta.optional.meta(omittable: true)
  end
end
