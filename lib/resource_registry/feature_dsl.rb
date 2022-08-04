# frozen_string_literal: true

require 'forwardable'

module ResourceRegistry
  # @api private
  # Domain-Specific Language (DSL) for defining {ResourceRegistry::Feature} objects
  class FeatureDSL
    extend Forwardable

    attr_reader :feature

    # @param [ResourceRegistry::Feature] feature Instance of a feature
    # @param [Hash] options Options passed through to feature enabled check
    # @yield the block to evaulate when calling the feature
    # @return [Mixed]
    def initialize(feature, options: {}, &_block)
      @feature = feature
      @options = options
    end

    def key
      @feature.key.to_s
    end

    # @return [String] the namespace under which the feature is stored, in dot notation
    def namespace
      @feature.namespace_path.path.map(&:to_s).join('.')
    end

    def assigned_namespace
      @feature.namespace.path.map(&:to_s).join('.')
    end

    # @!method enabled?
    # Check if a feature is enabled.
    # @return [true] If feature is enabled
    # @return [false] If feature is not enabled
    def_delegator :@feature, :is_enabled, :enabled?

    # @!method disabled?
    # Check if a feature is disabled
    # @return [true] If feature is disabled
    # @return [false] If feature is not disabled
    def disabled?
      @feature.is_enabled == false
    end

    def_delegator :@feature, :is_enabled

    # @!method item
    # The reference or code to be evaluated when feature is resolved
    def_delegator :@feature, :item

    # @!method options
    def_delegator :@feature, :options

    # @!method meta
    def_delegator :@feature, :meta

    # @return [Array<Setting>] all settings for the feature
    def settings(id = nil)
      return [] unless @feature.settings
      id.nil? ? @feature.settings : setting(id)
    end

    # @return [Setting] referenced setting for the feature
    def setting(id)
      raise ArgumentError, "#{id} must be a String or Symbol" if !id.is_a?(String) && !id.is_a?(Symbol)

      id = id.to_sym
      @feature.settings.detect { |setting| setting.key == id }
    end

    def label
      @feature.meta.label
    end

    def default_value
      @feature.meta.default
    end

    def value
      @feature.meta.value
    end

    def type
      @feature.meta.type
    end

    def enumerations
      @feature.meta.enum
    end

    def description
      @feature.meta.description
    end

    def required?
      @feature.meta.is_required
    end

    def visible?
      @feature.meta.is_visible
    end

    def display_order
      @feature.meta.order
    end

    def item
      elements = @feature.item.to_s.split(/\./)

      if defined? Rails
        elements[0].constantize.send(elements[1])
      else
        Module.const_get(elements[0]).send(elements[1])
      end
    rescue NameError
      @feature.item
    end
  end
end
