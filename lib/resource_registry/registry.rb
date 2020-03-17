# frozen_string_literal: true

require_relative 'operations/registries/configure'
require_relative 'operations/registries/create'
require_relative 'operations/registries/load'

module ResourceRegistry

  # Registries are containers for storing and accessing an application's {ResourceRegistry::Feature} and setting values
  class Registry < Dry::Container

    FEATURE_INDEX_NAMESPACE = 'feature_index'.freeze

    # attr_accessor :name, :load_path, :created_at


    # @return ResourceRegistry::Registry
    def initialize
      super()

      @features = []
      @features_stale = true
    end

    # Set options for this Registry. See {ResourceRegistry::Configuration} for setting attributes
    def configure(&block)
      config = OpenStruct.new
      yield(config)
      ResourceRegistry::Operations::Registries::Configure.new.call(self, config.to_h)
    end

    # Store a feature in the registry
    # @param [ResourceRegistry::Feature] The subject feature to be stored
    # @raise [ArgumentError] if the feature_entity parameter isn't an instance of {ResourceRegistry::Feature}
    # @raise [ResourceRegistry::Error::DuplicateFeatureError] if a feature is already registered under this key in the registry
    # @return [ResourceRegistry::Registry]
    def register_feature(feature_entity)
      if !feature_entity.is_a?(ResourceRegistry::Feature)
        raise ArgumentError, "#{feature_entity} must be a ResourceRegistry::Feature"
      end

      feature = dsl_for(feature_entity)

      if feature_exist?(feature.key)
        raise ResourceRegistry::Error::DuplicateFeatureError, "#{feature.key.inspect} feature is already registered"
      end

      @features_stale = true
      # "feature_index.greeter_feature_1" => "level_1.level_2.level_3.greeter_feature_1"
      register(namespaced(feature.key, FEATURE_INDEX_NAMESPACE), proc { resolve(namespaced(feature.key, feature.namespace)) })
      register(namespaced(feature.key, feature.namespace), feature)
      self
    end

    # Look up a feature stored in the registry
    # @param [Symbol] feature_key unique identifier for the subject feature
    # @param [hash] options
    def resolve_feature(feature_key, &block)
      feature = resolve(namespaced(feature_key, FEATURE_INDEX_NAMESPACE), &block)
      block_given? ? feature.item.call(yield) : feature
    end

    # (see #resolve_feature)
    # @note This is syntactic sugar for {resolve_feature}
    def [](key, &block)
      if key?(namespaced(key, FEATURE_INDEX_NAMESPACE))
        resolve_feature(key, &block)
      else
        resolve(key, &block)
      end
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

    # Indicates if a feature with a matching feature_key is stored in the registry
    # @param [Symbol] feature_key unique identifier for the subject feature
    # @return [ResourceRegistry::Feature] if feature is found in registry
    # @return [false] if feature_key isn't found in registry
    def feature_exist?(feature_key)
      key?(namespaced(feature_key, FEATURE_INDEX_NAMESPACE)) ? resolve_feature(feature_key) : false
    end

    # Indicates if a feature is enabled.  To be considered enabled the subject feature
    # plus all its parent features must be in enabled state
    # @param [Symbol] feature_key unique identifier for the subject feature
    # @return [true] if feature_key is enabled
    # @return [ResourceRegistry::Feature] if feature is found in registry
    def feature_enabled?(feature_key)
      feature = resolve_feature(feature_key)
      return false unless feature.enabled?

      namespaces = feature.namespace.split('.')
      namespaces.detect(-> {true}) do |ancestor_key|
        feature_exist?(ancestor_key) ? resolve_feature(ancestor_key.to_sym).disabled? : false
      end
    end

    def features_by_namespace(namespace)
      keys.reduce([]) { |list, key| list << strip_namespace(key).to_sym if key_in_namespace?(key, namespace); list }
    end

    private

    def dsl_for(feature)
      ResourceRegistry::FeatureDSL.new(feature)
    end

    def features_stale?
      @features_stale
    end

    def is_indexed_feature?(feature_key)
      (/\A#{Regexp.escape(FEATURE_INDEX_NAMESPACE)}/ =~ feature_key.to_s) == 0
    end

    def key_in_namespace?(key, namespace)
      ((/\A#{Regexp.escape(namespace.to_s)}/ =~ key) == 0) && (key.delete_prefix(namespace + '.').count('.') == 0)
    end

    def parent_namespace(feature_key)
      parts = feature_key.to_s.split('.')
      parts[0..(parts.size - 2)].join('.')
    end

    def strip_namespace(feature_key)
      feature_key.to_s.split('.').last
    end

    # Concatenate a namespace with a feature key
    # @param [String] namespace
    # @param [Symbol] feature_key
    # @return [String] A key with namespace prepended key in dot notation
    def namespaced(key, namespace = '')
      [namespace, key.to_s].join('.').to_s
    end

  end
end
