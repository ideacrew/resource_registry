# frozen_string_literal: true

module ResourceRegistry

  # A container for regsitering and accessing Features and setting values
  class Registry < Dry::Container

    FEATURE_INDEX_NAMESPACE = 'feature_index'.freeze
    # extend Dry::Container::Mixin

    # @params [Symbol] key ID for this Registry instance
    # @params [ResourceRegistry::Configuration] configuration Registry configuration entity
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

    # Register a feature in the registry, including adding a reference to the
    # feature index namespace
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
    end

    def resolve_feature(feature_key)
      resolve(index_key_for(feature_key))
    end

    # @return list of registered features
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

    # @param [Symbol] id Key for the subject Feature
    # @return [ResourceRegistry::Feature] If feature is found in Registry
    # @return [false] If feature isn't found in Registry
    def feature_exist?(feature_key)
      key?(index_key_for(feature_key))
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
