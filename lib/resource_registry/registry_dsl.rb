require 'forwardable'

module ResourceRegistry

  # Define a Domain-Specific Language (DSL) for ResourceRegisty::Registry container object
  class RegistryDSL
    extend Forwardable

    def_delegator :@registry, :register
    def_delegator :@registry, :resolve

    attr_reader :registry

    # @param [ResourceRegistry::Registry] registry Instance of a registry
    # @param [Hash] options Options passed through to registry enabled check
    def initialize(registry:, options: {})
      @registry = registry
      @options  = options

      @memoized_namespaces  = {}
      @memoized_features    = {}
    end

    def register(feature)
      # validate and find_or_create namespace if populated

      # add the feature to index
      # add the feature to namespace
    end


    def resolve(feature_key)

    end


    def features
      @registry
    end

    # @param [Symbol] id Key for the subject Feature
    # @return [ResourceRegistry::Feature] If feature is found in Registry
    # @return [false] If feature isn't found in Registry
    def exist?(feature_key)
      @memoized_features.fetch(feature_key, false)
    end


    private

    def memoize_namespace
    end

    def memoize_feature
    end

    def features_by_namespace(namespace)
      @registry.keys.reduce([]) do |list, key|
      end
    end

  end
end