# frozen_string_literal: true

module ResourceRegistry
  class Configuration < Dry::Struct

    # @!attribute [r] name (required)
    # Unique identifier
    # @return [Symbol]
    attribute :name,              Types::RequiredSymbol.meta(omittable: false)

    # @!attribute [r] root (required)
    # System root directory
    # @return [String]
    attribute :root,              Types::String.optional.meta(omittable: false)

    # @!attribute [r] created_at (optional)
    # Timestamp when this instance was initialized
    # @return [DateTime]
    attribute :created_at,        Types::CallableDateTime.meta(omittable: false)

    # @!attribute [r] settings (optional)
    # Include meta attribute values when registering Features
    # @return [Boolean]
    attribute :register_meta,     Types::Bool.default(false).meta(omittable: false)

    # @!attribute [r] system_dir (optional)
    # Dir path relative to root, where bootable components
    # @return [String]
    attribute :system_dir,        Types::String.optional.meta(omittable: true)

    # @!attribute [r] default_namespace (optional)
    # Specify the namespace resolver will default
    # @return [String]
    attribute :default_namespace, Types::String.optional.meta(omittable: true)

    # @!attribute [r] auto_register (optional)
    # Dir path where defined classes are automatically registered into container
    # @return [String]
    attribute :auto_register,     Types::Array.of(String).optional.meta(omittable: true)

    # @!attribute [r] load_path (optional)
    # Configure $LOAD_PATH to include referenced directory
    # @return [String]
    attribute :load_path,         Types::String.optional.meta(omittable: true)

    # @!attribute [r] settings (optional)
    # Configuration settings and values for this Feature
    # @return [Array<ResourceRegistry::Setting>]
    # @return [Array<ResouceRegistry::Setting>]
    attribute :settings,          Types::Array.of(String).optional.meta(omittable: true)

  end
end
