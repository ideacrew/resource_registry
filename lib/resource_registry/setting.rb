# frozen_string_literal: true

require_relative 'validation/setting_contract'

module ResourceRegistry
  class Setting < Dry::Struct

    # @!attribute [r] key
    # ID for this setting
    # @return [Symbol]
    attribute :key,     Types::Symbol.meta(omittable: false)

    # @!attribute [r] item
    # The value for this setting
    # @return [Any]
    attribute :item,    Types::Any.meta(omittable: false)

    # @!attribute [r] options
    # Options passed through for this setting
    # @return [Hash]
    attribute :options, Types::Any.optional.meta(omittable: true)

    # @!attribute [r] meta
    # Configuration settings and attributes that support presenting and updating
    # their values in the User Interface
    # @return [ResourceRegistry::Meta]
    attribute :meta,    ResourceRegistry::Meta.optional.meta(omittable: true)


  end
end
