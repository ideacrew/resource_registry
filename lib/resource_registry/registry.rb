# frozen_string_literal: true

module ResourceRegistry

  # A container for regsitering and accessing Features and setting values
  class Registry < Dry::Container
    # extend Dry::Container::Mixin

    # @params [Symbol] key
    # @params [Hash] conf
    # @return ResourceRegistry::Registry
    def initialize(key:, conf: {})
      # configuration = configure(conf)

      super()
    end
  
    def register_feature(feature)
      binding.pry

      # super(feature.key, -> { self.resolve(:data_store)[:users] })

    end

    def resolve_feature(key:)
    
    end

    private

    def configure(params)
      default_conf = ResourceRegistry::Configuration.new.to_h
      values = default_conf.merge(params)
      ResourceRegistry::Operations::Configurations::Create.call(values)
    end

    def index_feature(feature)
    end

    def find_or_create_namespace(namespace)

    end

  end
end
