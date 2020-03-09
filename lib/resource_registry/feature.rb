# frozen_string_literal: true

require_relative 'validation/feature_contract'

require_relative 'operations/features/create'
require_relative 'operations/features/configure'
require_relative 'operations/features/disable'
require_relative 'operations/features/enable'

module ResourceRegistry
  class Feature < Dry::Struct

    # @!attribute [r] key (required)
    # Identifier for this Feature. Must be unique within a registry namespace
    # @return [Symbol]
    attribute :key,         Types::Symbol.meta(omittable: false)

    attribute :namespace,   Types::Array.of(Types::RequiredSymbol).default([].freeze).meta(omittable: false)

    # @!attribute [r] is_enabled  (required)
    # Availability state of this Feature in the application: either enabled or disabled
    # @return [true] If feature is enabled
    # @return [false] If feature is disabled
    attribute :is_enabled,  Types::Bool.default(false).meta(omittable: false)

    # @!attribute [r] item (required)
    # The reference or code to be evaluated when feature is resolved
    # @return [Any]
    attribute :item,        Types::Any.meta(omittable: true)

    # @!attribute [r] options
    # Options passed through for item execution
    # The user-assigned values passed through for this configuratino setting
    # @return [Hash]
    attribute :options,     Types::Any.meta(omittable: true)

    # @!attribute [r] meta (optional)
    # Configuration settings and attributes that support presenting and updating their values in the User Interface
    # @return [ResourceRegistry::Meta]
    attribute :meta,        ResourceRegistry::Meta.default(Hash.new.freeze).meta(omittable: true)

    # @!attribute [r] settings (optional)
    # Configuration settings and values for this Feature
    # @return [Array<ResourceRegistry::Setting>]
    attribute :settings,    Types::Array.of(ResourceRegistry::Setting).default([].freeze).meta(omittable: true)

  end
end


module Features

  # class << self
  #   attr_accessor :configuration

  #   # Get or initilize the configuration settings
  #   #
  #   # @example Get the settings.
  #   #   Features.configuration
  #   #
  #   # @return [ Hash ] The setting options.
  #   def configuration
  #     @configuration ||= Dry::Container.new
  #   end

  #   def enable(key)
  #     key.is_enabled = true
  #   end

  #   def disable(key)
  #     key.is_enabled = false
  #   end

  #   def enabled?(key)
  #     key.is_enabled == true
  #   end

  #   def disabled?(key)
  #     key.is_enabled == false
  #   end

  #   # Define a configuration option with a default.
  #   #
  #   # @example Define the option.
  #   #   Features.option(:logger, :default => Logger.new(STDERR, :warn))
  #   #
  #   # @param [Symbol] feature The name of the feature to load
  #   def load(feature)
  #     # yield configuration if block_given
  #     # configuration.register(feature) || do
  #     #   :result
  #     # end

  #     container.register(key, options)
  #     build_class_methods(key)
  #   end

  #   def create_method(name, &block)
  #     self.class.send(:define_method, name, &block)
  #   end

  #   def build_class_methods(key)
  #     module_eval do
  #       create_method(name) { configuration[name] }

  #       # define_method(name) do
  #       #   configuration[name]
  #       # end

  #       define_method("#{name}=") do |value|
  #         configuration[name] = value
  #       end

  #       define_method("#{name}?") do
  #         !!send(name)
  #       end
  #     end
  #   end

  # end
end
