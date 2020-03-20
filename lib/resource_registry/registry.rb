# frozen_string_literal: true

require 'dry/container'
require_relative 'operations/registries/load'
require_relative 'operations/registries/configure'
require_relative 'operations/registries/create'

module ResourceRegistry

  # Registries are containers for storing and accessing an application's {ResourceRegistry::Feature} and setting values
  class Registry < Dry::Container

    FEATURE_INDEX_NAMESPACE = 'feature_index'.freeze
    CONFIGURATION_NAMESPACE = 'configuration'.freeze

    # @return ResourceRegistry::Registry
    def initialize
      super()

      @configurations = {}
      @features       = []
      @features_stale = true
    end

    # Set options for this Registry. See {ResourceRegistry::Configuration} for configurable attributes
    def configure(&block)
      config = OpenStruct.new
      yield(config)

      ResourceRegistry::Operations::Registries::Configure.new.call(self, config.to_h)
    end

    # Store a feature in the registry
    # @param feature [ResourceRegistry::Feature] The subject feature to be stored
    # @raise [ArgumentError] if the feature parameter isn't an instance of {ResourceRegistry::Feature}
    # @raise [ResourceRegistry::Error::DuplicateFeatureError] if this feature key is already registered under in the registry
    # @return [ResourceRegistry::Registry]
    def register_feature(feature)
      if !feature.is_a?(ResourceRegistry::Feature)
        raise ArgumentError, "#{feature} must be a ResourceRegistry::Feature"
      end

      feature = dsl_for(feature)

      if !feature?(feature.key)
        @features_stale = true
        register(namespaced(feature.key, FEATURE_INDEX_NAMESPACE), proc { resolve(namespaced(feature.key, feature.namespace)) })
        register(namespaced(feature.key, feature.namespace), feature)
      else
        raise ResourceRegistry::Error::DuplicateFeatureError, "feature already registered #{feature.key.inspect}"
      end

      self
    end

    # Look up a feature stored in the registry
    # @param key [Symbol] unique identifier for the subject feature
    # @raise [ResourceRegistry::Error::FeatureNotFoundError] if a feature with this key isn't found in the registry
    # @return [mixed] the value stored in Feature's item attribute
    def resolve_feature(key, &block)
      if feature?(key)
        feature = resolve(namespaced(key, FEATURE_INDEX_NAMESPACE), &block)
        block_given? ? feature.item.call(yield) : feature
      else
        raise ResourceRegistry::Error::FeatureNotFoundError, "nothing registered with key #{key}"
      end
    end

    # (see #resolve_feature)
    # @note This is syntactic sugar for {resolve_feature}.  To maintain full container functionality, this method
    #   will first attempt to lookup a Feature that matches the key and if unsuccessful will directly resolve the key value 
    # @raise [Dry::Container::Error] if neither a Feature nor other registry attribute matches the passed key
    def [](key, &block)
      resolve_feature(key, &block)
    rescue ResourceRegistry::Error::FeatureNotFoundError
      super
    end

    # Indicates if a feature with a matching key is stored in the registry
    # @param key [Symbol] unique identifier for the subject feature
    # @return [true] if feature is found in registry
    # @return [false] if key isn't found in registry
    def feature?(key)
      key?(namespaced(key, FEATURE_INDEX_NAMESPACE))
    end

    # Produce an enumerated list of all features stored in this registry
    # @return [Array<Symbol>] list of registered features
    def features
      if features_stale?
        @features = self.keys.reduce([]) do |list, key|
          list << strip_namespace(key).to_sym if is_indexed_feature?(key)
          list
        end
        @features_stale = false
      end
      @features
    end

    # Produce an enumerated list of all features stored in a specific namespace
    # @return [Array<Symbol>] list of registered features in the referenced namespace
    def features_by_namespace(namespace)
      keys.reduce([]) { |list, key| list << strip_namespace(key).to_sym if key_in_namespace?(key, namespace); list }
    end

    # Return the value for an individual configuration key
    # @raise [Dry::Container::Error] if key isn't a defined configuration attribute
    # @return [Mixed] value of the configuration attribute
    def configuration(key)
      resolve(namespaced(key, CONFIGURATION_NAMESPACE))
    end

    # Produce a map of all configuration values stored in this registry
    # @return [Hash] map of configuration key/value pairs
    def configurations
      return @configurations if @configurations.size > 0
      @configurations = keys.reduce({}) do |list, key|
        list.merge!(strip_namespace(key).to_sym => resolve(key)) if key_in_namespace?(key, CONFIGURATION_NAMESPACE)
        list
      end
    end

    # Indicates if a feature is enabled.  To be considered enabled the subject feature
    # plus all its ancestor features must be in enabled state. Ancestor features are any
    # that are registered in this feature's namespace tree
    # @param key [Symbol] unique identifier for the subject feature
    # @return [true] if feature and all its ancestors are enabled
    # @return [false] if feature or one of its ancestors isn't enabled
    def feature_enabled?(key)
      feature = resolve_feature(key)
      return false unless feature.enabled?

      namespaces = feature.namespace.split('.')
      namespaces.detect(-> {true}) do |ancestor_key|
        feature?(ancestor_key) ? resolve_feature(ancestor_key.to_sym).disabled? : false
      end
    end

    private

    def dsl_for(feature)
      ResourceRegistry::FeatureDSL.new(feature)
    end

    def features_stale?
      @features_stale
    end

    def is_indexed_feature?(key)
      (/\A#{Regexp.escape(FEATURE_INDEX_NAMESPACE)}/ =~ key.to_s) == 0
    end

    def key_in_namespace?(key, namespace)
      ((/\A#{Regexp.escape(namespace.to_s)}/ =~ key) == 0) && (key.delete_prefix(namespace + '.').count('.') == 0)
    end

    def parent_namespace(key)
      parts = key.to_s.split('.')
      parts[0..(parts.size - 2)].join('.')
    end

    def strip_namespace(key)
      key.to_s.split('.').last
    end

    # Concatenate a namespace with a feature key
    # @param key [String] the feature key value to concat
    # @param namespace [String] the namespace value to concat in dot notation
    # @return [String] the namespace prepended to key
    def namespaced(key, namespace = '')
      [namespace, key.to_s].join('.').to_s
    end

  end
end
