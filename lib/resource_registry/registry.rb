# frozen_string_literal: true

require 'dry/container'
require_relative 'operations/registries/load'
require_relative 'operations/registries/configure'
require_relative 'operations/registries/create'

module ResourceRegistry
  # Registries are containers for storing and accessing an application's {ResourceRegistry::Feature} and setting values
  class Registry < Dry::Container

    FEATURE_INDEX_NAMESPACE = 'feature_index'
    CONFIGURATION_NAMESPACE = 'configuration'

    attr_accessor :db_connection

    # @return ResourceRegistry::Registry
    def initialize
      super()

      @configurations = {}
      @features       = []
      @features_stale = true
    end

    # Set options for this Registry. See {ResourceRegistry::Configuration} for configurable attributes
    def configure
      config = OpenStruct.new
      yield(config)

      ResourceRegistry::Operations::Registries::Configure.new.call(self, config.to_h)
    end

    def swap_feature(feature)
      self._container.delete("feature_index.#{feature.key}")
      self._container.delete(namespaced(feature.key, feature.namespace))
      register_feature(feature)
      @features_stale = false
    end

    # Store a feature in the registry
    # @param feature [ResourceRegistry::Feature] The subject feature to be stored
    # @raise [ArgumentError] if the feature parameter isn't an instance of {ResourceRegistry::Feature}
    # @raise [ResourceRegistry::Error::DuplicateFeatureError] if this feature key is already registered under in the registry
    # @return [ResourceRegistry::Registry]
    def register_feature(feature)
      raise ArgumentError, "#{feature} must be a ResourceRegistry::Feature or ResourceRegistry::FeatureDSL" if !feature.is_a?(ResourceRegistry::Feature) && !feature.is_a?(ResourceRegistry::FeatureDSL)

      feature = dsl_for(feature)

      raise ResourceRegistry::Error::DuplicateFeatureError, "feature already registered #{feature.key.inspect}" if feature?(feature.key)
      @features_stale = true

      register(namespaced(feature.key, FEATURE_INDEX_NAMESPACE), proc { resolve(namespaced(feature.key, feature.namespace)) })
      register(namespaced(feature.key, feature.namespace), feature)

      self
    end

    # Look up a feature stored in the registry
    # @param key [Symbol] unique identifier for the subject feature
    # @raise [ResourceRegistry::Error::FeatureNotFoundError] if a feature with this key isn't found in the registry
    # @return [mixed] the value stored in Feature's item attribute
    def resolve_feature(key, &block)
      raise ResourceRegistry::Error::FeatureNotFoundError, "nothing registered with key #{key}" unless feature?(key)
      feature = resolve(namespaced(key, FEATURE_INDEX_NAMESPACE), &block)

      if block_given?
        feature.enabled? ? feature.item.call(yield) : Success(yield)
      else
        feature
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

    def namespaces
      return @namespaces if defined? @namespaces
      @namespaces = features.collect{|feature_key| self[feature_key].feature.namespace}.uniq
    end

    def namespace_features_hash
      dotted_namespaces = namespaces.collect{|ns| ns.map(&:to_s).join('.')}

      dotted_namespaces.inject({}) do |data, namespace|
        features = visible_features_by_namespace(namespace)
        data[namespace] = features if features.present?
        data
      end
    end

    def nested_namespaces
      return @nested_namespaces if defined? @nested_namespaces

      @nested_namespaces = namespace_features_hash.reduce({}) do |data, (namespace, features)|
        data.deeper_merge(namespace_to_hash(namespace.split('.'), features))
      end
    end

    # Produce an enumerated list of all features stored in a specific namespace
    # @return [Array<Symbol>] list of registered features in the referenced namespace
    def features_by_namespace(namespace)
      keys.reduce([]) do |list, key|
        list << strip_namespace(key).to_sym if key_in_namespace?(key, namespace)
        list
      end
    end

    # Produce an enumerated list of all visible features stored in a specific namespace
    # @return [Array<Symbol>] list of registered visible features in the referenced namespace
    def visible_features_by_namespace(namespace)
      feature_keys = features_by_namespace(namespace)
      feature_keys.select{|feature_key| resolve_feature(feature_key)&.meta&.is_visible }
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
      return @configurations unless @configurations.empty?
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
      namespaces.all? do |ancestor_key|
        feature?(ancestor_key) ? resolve_feature(ancestor_key.to_sym).enabled? : true
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
      namespace.present? ? [namespace, key.to_s].join('.') : key.to_s
    end

    def namespace_to_hash(namespace_arr, features)
      namespace_hash = {}

      key = namespace_arr[0]
      namespace_hash[key] = (!namespace_arr[1..-1].empty? ? {namespaces: namespace_to_hash(namespace_arr[1..-1], features)} : {features: features})
      namespace_hash
    end

    # def namespace_to_hash(namespace_arr)
    #   namespace_hash = {}
    #   # key = namespace_arr.shift
    #   # namespace_hash[key] = (namespace_arr.size > 0 ? namespace_to_hash(namespace_arr) : nil)

    #   key = namespace_arr[0]
    #   namespace_hash[key] = (namespace_arr[1..-1].size > 0 ? namespace_to_hash(namespace_arr[1..-1]) : nil)
    #   namespace_hash
    # end
  end
end
