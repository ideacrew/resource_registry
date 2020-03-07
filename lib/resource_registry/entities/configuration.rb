# frozen_string_literal: true

module ResourceRegistry
  class Configuration < Dry::Struct

    # @!attribute [r] name
    # Identifier for the target registry
    # @return [Symbol]
    attribute :name,              Types::RequiredSymbol.meta(omittable: false)

    # @!attribute [r] root
    # System root directory
    # @return [Pathname]
    attribute :root,              Types::Path.meta(omittable: false)

    # @!attribute [r] created_at 
    # Timestamp when this instance was initialized
    # @return [DateTime]
    attribute :created_at,        Types::DateTime.default(->{DateTime.now}.freeze).meta(omittable: false)

    # @!attribute [r] settings 
    # Include meta attribute values when registering Features
    # @return [Bool]
    attribute :register_meta,     Types::Bool.default(false).meta(omittable: false)

    # @!attribute [r] system_dir 
    # Dir path relative to root, where bootable components
    # @return [String]
    attribute :system_dir,        Types::String.optional.meta(omittable: true)

    # @!attribute [r] default_namespace 
    # Specify the namespace resolver will use when a namespace isn't specified
    # @return [String]
    attribute :default_namespace, Types::String.optional.meta(omittable: true)

    # @!attribute [r] auto_register 
    # Dir path where defined classes are automatically registered into container
    # @return [String]
    attribute :auto_register,     Types::Array.of(String).optional.meta(omittable: true)

    # @!attribute [r] load_path 
    # Configure $LOAD_PATH to include referenced directory
    # @return [String]
    attribute :load_path,         Types::String.optional.meta(omittable: true)

    # @!attribute [r] settings 
    # Configuration settings and values for this Feature
    # @return [Array<ResourceRegistry::Setting>]
    attribute :settings,          Types::Array.of(ResourceRegistry::Setting).optional.meta(omittable: true)
  end
end
