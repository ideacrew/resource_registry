# frozen_string_literal: true

require 'forwardable'

module ResourceRegistry
  # @api private
  # Domain-Specific Language (DSL) for defining {ResourceRegistry::Setting} objects
  class SettingDSL
    extend Forwardable

    attr_reader :setting

    # @param [ResourceRegistry::Setting] setting Instance of a setting
    # @yield the block to evaulate when calling the setting
    # @return [Mixed]
    def initialize(setting, &_block)
      @setting  = setting
    end

    def key
      @setting.key.to_s
    end

    # @!method item
    # The reference or code to be evaluated when setting is resolved
    def_delegator :@setting, :item

    # @!method meta
    def_delegator :@setting, :meta

    def label
      @setting.meta.label
    end

    def default_value
      @setting.meta.default
    end

    def value
      @setting.meta.value
    end

    def type
      @setting.meta.type
    end

    def enumerations
      @setting.meta.enum
    end

    def description
      @setting.meta.description
    end

    def required?
      @setting.meta.is_required
    end

    def visible?
      @setting.meta.is_visible
    end

    def display_order
      @setting.meta.order
    end

    # registry[:feature_key]
    # registry.resolve(:feature_key)
    def item
      value = @setting.item.to_s

      if matched = value.match(/^registry\[(.*)\]$/) || matched = value.match(/^registry.resolve_feature\((.*)\)$/)
        feature_key = matched[-1].gsub(':', '')
        return registry[feature_key]
      end

      elements = value.split(/\./)
       
      if defined? Rails
        elements[0].constantize.send(elements[1])
      else
        Module.const_get(elements[0]).send(elements[1])
      end
    rescue NameError
      @setting.item
    end

    def registry
      return @registry if defined? @registry
      
      if defined? Rails
        @registry = "#{Rails.application.class.module_parent_name}Registry".constantize
      end
    end
  end
end
