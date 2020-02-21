# frozen_string_literal: true

module ResourceRegistry
  module Entities

    # Attributes for storing configuration values and driving their presentation in User Interface 
    class Meta < Dry::Struct

      # @!attribute [r] label (optional)
      # Text for this setting intended as label in the UI
      # @return [String]
      attribute :label,       Types::String.optional.meta(omittable: true)

      # @!attribute [r] type (optional)
      # The data input kind to render on the form
      # @return [String]      
      attribute :type,        Types::Symbol.optional.meta(omittable: true)

      # @!attribute [r] default (optional)
      # The system-assigned value for this configuratino setting.  Used when a user-assigned value 
      # isn't or to restore original setting value when reset
      # @return [Any]
      attribute :default,     Types::Any.optional.meta(omittable: true)

      # @!attribute [r] description (optional)
      # Concise explanaion of how the configuration setting affects system behaviout.  Usually presented 
      # as help text in the UI
      # @return [String]      
      attribute :description, Types::String.optional.meta(omittable: true)

      # @!attribute [r] choices (optional)
      # List of vaalid domain values when configuration values are constrained to an enumerated set
      # @return [Array<Any>] 
      attribute :enum,     Types::Array.of(Types::Any).optional.meta(omittable: true)

      # @!attribute [r] is_visible (optional)
      # Internal indicator whether the configuration setting value must be set in the UI
      # @return [Boolean]          
      attribute :is_required, Types::Bool.optional.meta(omittable: true)

      # @!attribute [r] is_visible (optional)
      # Internal indicator whether the configuration setting should appear in the UI
      # @return [Boolean]          
      attribute :is_visible,  Types::Bool.optional.meta(omittable: true)

      # @!attribute [r] authorization (optional)
      # (FUTURE) System roles granted privilige to update this Feature and associated configuration values
      # @return [Array<ResourceRegistry::Entities::Authorization>]
      attribute :authorization,  Types::Array.of(ResourceRegistry::Entities::AccountRole).optional.meta(omittable: true)

      # @!attribute [r] order (optional)
      # Internal value used to sequence attributes appearance in the UI. Order value is scoped to 
      # local namespace. Ignored on attributes where is_visible == false
      # @return [Boolean]          
      attribute :order,       Types::Bool.optional.meta(omittable: true)

    end
  end
end
