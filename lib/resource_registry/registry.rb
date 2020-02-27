# frozen_string_literal: true

module ResourceRegistry

  # A container for regsitering and accessing Features and setting values
  class Registry < Dry::Container
    # extend Dry::Container::Mixin

    # @params [Symbol] key
    # @params [Hash] conf
    # @return ResourceRegistry::Registry
    def initialize(key:, conf: {})
      configuration = configure(conf)

      super
    end

    def register(feature)
      # validate feature_hash using feature_contract
      # instantiate a feature struct

      # validate and find_or_create namespace if populated

      # add the feature to index
      # add the feature to namespace
    end

    def resolve(key:)

    end

    private

    def configure(params)
      default_conf = ResourceRegistry::Configuration.new.to_h
      values = default_conf.merge(params)
      ResourceRegistry::Operations::Configurations::Create.call(values) 
    end

    def index_feature(feature)
    end

  end
end
