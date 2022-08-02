# frozen_string_literal: true

require_relative 'validation/namespace_path_contract'

module ResourceRegistry
  # Define a Feature together with its settings, code hook for dependency injection, and configuration UI attributes
  #
  # @example Define the feature
  #   Feature.new(key: :greeter, item: proc { |name| "Hello #{name}!" })
  #   Feature.new(key: :logger, item: Logger.new(STDERR), settings: [{default: :warn}])
  class NamespacePath < Dry::Struct
    # @!attribute [r] item (required)
    # The reference or code to be evaluated when feature is resolved
    # @return [Any]
    attribute :path,  Types::Array.of(Types::RequiredSymbol).optional.meta(omittable: false)

    # @!attribute [r] meta (optional)
    # Configuration settings and attributes that support presenting and updating their values in the User Interface
    # @return [ResourceRegistry::Meta]
    attribute :meta,  ::ResourceRegistry::Meta.optional.meta(omittable: true)
  end
end