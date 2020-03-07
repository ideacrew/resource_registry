# frozen_string_literal: true

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

    # Store a feature in the registry
    # @param [Symbol] feature_key Unique identifier for the subject feature
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

      register(index_key_for(feature.key), proc { resolve(namespace_key_for(feature)) })
      register(namespace_key_for(feature), feature)
      self
    end

    # @param [Symbol] feature_key unique identifier for the subject feature
    # @param [hash] options 
    def resolve_feature(feature_key, options = {})
      resolve(index_key_for(feature_key))
    end

    # 
    # @return [Array<ResourceRegistry::FeatureDSL>] list of registered features
    def features
      if features_stale?
        @features = self.keys.reduce([]) do |list, key|
          list << strip_index_namespace(key).to_sym if in_index_namespace?(key)
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
      key?(index_key_for(feature_key)) ? resolve_feature(index_key_for(feature_key)) : false
    end


    private

    def dsl_for(feature)
      ResourceRegistry::FeatureDSL.new(feature)
    end

    def features_stale?
      @features_stale
    end

    def in_index_namespace?(feature_key)
      (/\A#{Regexp.escape(FEATURE_INDEX_NAMESPACE)}/ =~ feature_key) == 0
    end

    def strip_index_namespace(feature_key)
      ns_size = FEATURE_INDEX_NAMESPACE.size + 1
      feature_key[ns_size, feature_key.to_s.length - ns_size]
    end

    def namespace_key_for(feature)
      [feature.namespace, feature.key.to_s].join('.').to_s
    end

    # Add the feature index namespace to a feature key
    # @param [ResourceRegistry::FeatureDSL] feature_key
    # @return [String] A key with the feature index namespace prepended in dot notation
    def index_key_for(feature_key)
      [FEATURE_INDEX_NAMESPACE, feature_key.to_s].join('.').to_s
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
