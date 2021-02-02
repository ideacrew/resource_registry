# frozen_string_literal: true

require_relative 'validation/namespace_contract'
require_relative 'operations/namespaces/build'
require_relative 'operations/namespaces/create'
require_relative 'operations/namespaces/form'
require_relative 'operations/namespaces/update_features'
require_relative 'operations/namespaces/list_features'
require_relative 'operations/graphs/create'

module ResourceRegistry
  # Define a namespace container for organizing features
  #
  # @example Define the namespace
  #   Namespace.new(key: 'ue46632342', path: [:app, :greeter])
  class Namespace < Dry::Struct

    # @!attribute [r] key (required)
    # Identifier for this Namespace. 10 character long MD5 digest key
    # @return [Symbol]
    attribute :key,         Types::Symbol.meta(omittable: false)

    # @!attribute [r] path (required)
    # The registry namespace where this item is stored
    # @return [Array<Symbol>]
    attribute :path,        Types::Array.of(Types::RequiredSymbol).default([].freeze).meta(omittable: false)

    # @!attribute [r] meta (optional)
    # Configuration settings and attributes that support presenting and updating their values in the User Interface
    # @return [ResourceRegistry::Meta]
    attribute :meta,        ResourceRegistry::Meta.default(Hash.new.freeze).meta(omittable: true)

    # @!attribute [r] feature_keys (optional)
    # Key references to the features under this namespace
    # @return [Array<Symbol>]
    attribute :feature_keys,  Types::Array.of(Types::RequiredSymbol).default([].freeze).meta(omittable: true)

    # @!attribute [r] features (optional)
    # @deprecated Use {feature_keys} instead
    # List of full feature definitions under this namespace
    # @return [Array<ResourceRegistry::Feature>]
    attribute :features,    Types::Array.of(::ResourceRegistry::Feature).meta(omittable: true)

    # @!attribute [r] namespaces (optional)
    # Namespaces that are nested under this namespace
    # @return [Array<ResourceRegistry::Namespace>]
    attribute :namespaces,  Types::Array.of(::ResourceRegistry::Namespace).meta(omittable: true)


    def persisted?
        false
    end
  end
end