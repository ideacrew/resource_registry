# frozen_string_literal: true

require_relative 'validation/meta_contract'

module ResourceRegistry

  # Attributes for storing configuration values and driving their presentation in User Interface
  class Meta < Dry::Struct

    # @!attribute [r] label
    # Text for this setting intended as label in the UI
    # @return [String]
    attribute :label,       Types::String.optional.meta(omittable: true)

    # @!attribute [r] type
    # The data input kind to render on the form
    # @return [String]
    attribute :content_type,        Types::Symbol.optional.meta(omittable: true)

    # @!attribute [r] default
    # The system-assigned value for this configuration setting.  Used when a user-assigned value
    # isn't or to restore original setting value when reset
    # @return [Any]
    attribute :default,     Types::Any.optional.meta(omittable: true)

    # @!attribute [r] value
    # The user-assigned value for this configuration setting.
    # @return [Any]
    attribute :value,       Types::Any.optional.meta(omittable: true)

    # @!attribute [r] description
    # Concise explanaion of how the configuration setting affects system behaviout.  Usually presented
    # as help text in the UI
    # @return [String]
    attribute :description, Types::String.optional.meta(omittable: true)

    # @!attribute [r] enum
    # List of vaalid domain values when configuration values are constrained to an enumerated set
    # @return [Array<Any>]
    attribute :enum,        Types::Any.optional.meta(omittable: true)

    # @!attribute [r] is_required
    # Internal indicator whether the configuration setting value must be set in the UI
    # @return [Bool]
    attribute :is_required, Types::Bool.optional.meta(omittable: true)

    # @!attribute [r] is_visible
    # Internal indicator whether the configuration setting should appear in the UI
    # @return [Bool]
    attribute :is_visible,  Types::Bool.optional.meta(omittable: true)

    # @!attribute [r] authorization
    # (FUTURE) System roles granted privilige to update this Feature and associated configuration values
    # @return [Array<ResourceRegistry::Entities::Authorization>]
    # attribute :authorization,  Types::Array.of(ResourceRegistry::Entities::AccountRole).optional.meta(omittable: true)

    # @!attribute [r] order
    # Internal value used to sequence attributes appearance in the UI. Order value is scoped to
    # local namespace. Ignored on attributes where is_visible == false
    # @return [Bool]
    attribute :order,       Types::Bool.optional.meta(omittable: true)

  end
end
