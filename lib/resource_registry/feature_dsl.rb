# frozen_string_literal: true

require 'forwardable'

module ResourceRegistry

  # Define a Domain-Specific Language (DSL) for ResourceRegisty::Feature object
  class FeatureDsl
    extend Forwardable

    attr_reader :feature

    # @param [ResourceRegistry::Feature] feature Instance of a feature
    # @param [Hash] options Options passed through to feature enabled check
    def initialize(feature, options: {})
      @feature = feature
      @options = options
    end

    def key
      @feature.key.to_s
    end

    def_delegator :@feature, :item
    def_delegator :@feature, :options

    # Check if a feature is enabled
    #
    # @return [true] If feature is enabled
    # @return [false] If feature is not enabled
    def_delegator :@feature, :is_enabled, :enabled?

    # Check if a feature is disabled
    #
    # @return [true] If feature is disabled
    # @return [false] If feature is not disabled
    def disabled?
      @feature.is_enabled == false
    end

    def namespace
      @feature.namespace.map(&:to_s).join('.')
      # @feature.namespace.reduce("") { |str, ns| str == "" ? str = ns.to_s : str += ".#{ns.to_s}"; str }
    end

    def settings(id = nil)
      return [] unless @feature.settings
      id == nil ? @feature.settings : setting(id)
    end

    def setting(id)
      if !id.is_a?(String) && !id.is_a?(Symbol)
        raise ArgumentError, "#{id} must be a String or Symbol"
      end      

      id = id.to_sym
      @feature.settings.detect { |setting| setting.key == id }
    end

    def meta
      @feature.meta
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

  end
end
