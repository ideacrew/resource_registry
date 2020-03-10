# frozen_string_literal: true

require_relative 'operations/registries/configure'
require_relative 'operations/registries/create'
require_relative 'operations/registries/load'

module ResourceRegistry

  # Registries are containers for storing and accessing an application's {ResourceRegistry::Feature} and setting values
  class Registry < Dry::Container

    FEATURE_INDEX_NAMESPACE = 'feature_index'.freeze

    # @param [Symbol] identifier for this Registry instance
    # @param [ResourceRegistry::Configuration] configuration Registry configuration entity
    # @return ResourceRegistry::Registry
    def initialize(key: {}, options: {})
      super()

      @options  = options
      @features = []
      @features_stale = true

      # if !key.is_a?(String) && !key.is_a?(Symbol)
      #   raise ArgumentError, "#{key} must be a String or Symbol"
      # end

      # conf_options = options[:configuration] || {}
      # conf_options.merge!(name: key.to_sym)
      # compose_configuration(conf_options)

    end

    def configure(&block)
      ResourceRegistry::Operations::Registries::Configure.new.call(self, &block)
      load! if load_path_given?
    end

    def load_path_given?
      key?('configuration.load_path')
    end

    def load_path
      resolve('configuration.load_path')
    end

    def load!
      ResourceRegistry::Operations::Registries::Load.new.call(registry: self)
    end

    def register_configuration(configuration_entity)
      self.namespace(:configuration) do
        configuration_entity.to_h.each do |attribute, value|
          register(attribute, value)
        end
      end
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
      feature = resolve(namespaced(feature_key.to_s, FEATURE_INDEX_NAMESPACE), &block)
      block_given? ? feature.item.call(yield) : feature
    end

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

    def compose_configuration(conf_options)
      configuration = create_configuration(conf_options)
      assign_configuration(configuration)
    end

    def create_configuration(values)
      result = ResourceRegistry::Operations::Configurations::Create.call(values)
      result.success? ? result.value! : result.failure
    end

    def assign_configuration(configuration)
      configuration.attributes.each_pair { |k, v| register(k, v) }
    end

  end
end
