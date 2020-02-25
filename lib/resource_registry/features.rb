# frozen_string_literal: true

# require_relative 'entities/account_roles'

require_relative 'entities/meta'
require_relative 'entities/setting'
require_relative 'entities/feature'

require_relative 'validation/features/feature_contract'
require_relative 'validation/metas/meta_contract'
require_relative 'validation/settings/setting_contract'

require 'dry/monads'
require 'dry/monads/do'

require_relative 'operations/features/create'
require_relative 'operations/features/authorize'
require_relative 'operations/features/configure'
require_relative 'operations/features/disable'
require_relative 'operations/features/disabled'
require_relative 'operations/features/enable'
require_relative 'operations/features/enabled'
require_relative 'operations/features/enable'
require_relative 'operations/features/register'
require_relative 'operations/features/exist'


module ResourceRegistry
  module Features


    # => options
    # => parent_feature
    # => required?
    # => enabled?
    # => ui_metadata
    #     => :title
    #     => :type
    #     => :default
    #     => :value
    #     => :description
    #     => :choices
    #     => :is_required
    #     => :is_visible

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
end
