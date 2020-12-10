# frozen_string_literal: true

require_relative 'validation/namespace_contract'
require_relative 'operations/namespaces/build'
require_relative 'operations/namespaces/create'
require_relative 'operations/graphs/create'

module ResourceRegistry
  # Define a Feature together with its settings, code hook for dependency injection, and configuration UI attributes
  #
  # @example Define the feature
  #   Feature.new(key: :greeter, item: proc { |name| "Hello #{name}!" })
  #   Feature.new(key: :logger, item: Logger.new(STDERR), settings: [{default: :warn}])
  class Namespace < Dry::Struct

    # @!attribute [r] key (required)
    # Identifier for this Feature. Must be unique within a registry namespace
    # @return [Symbol]
    attribute :key,         Types::Symbol.meta(omittable: false)

    # @!attribute [r] item (required)
    # The reference or code to be evaluated when feature is resolved
    # @return [Any]
    attribute :path,        Types::Array.of(Types::RequiredSymbol).default([].freeze).meta(omittable: false)

    # @!attribute [r] meta (optional)
    # Configuration settings and attributes that support presenting and updating their values in the User Interface
    # @return [ResourceRegistry::Meta]
    attribute :meta,        ResourceRegistry::Meta.default(Hash.new.freeze).meta(omittable: true)

    attribute :feature_keys,    Types::Array.of(Types::RequiredSymbol).default([].freeze).meta(omittable: true)
  end
end