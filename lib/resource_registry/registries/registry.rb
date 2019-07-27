require 'dry/system/container' unless defined? Dry::System::Container

module ResourceRegistry
  module Registries
    class Registry

      # use :bootsnap
      # use :env, inferrer: -> { ENV.fetch("RAILS_ENV", :development).to_sym }

      def initialize(validation)
        @container  = container
        @validation = validation
        
        set_config
        set_load_paths 
        set_persistence
        # set_environment

        @container
      end

      def set_config
        @validation.output[:config].each_pair do |key, value|
          # @container.send(:configure, {key: value})
          @container.register("config.#{key}", value)
        end
      end

      def set_load_paths
        @container.load_paths! @validation.output[:load_paths]
      end


      def set_environment
        @container.send(:configure, {key: ENV.fetch("RAILS_ENV", :development).to_sym})
      end

      def set_persistence
        @validation.output[:persistence].each_pair do |key, value|
          @container.register("persistence.#{key}", value)
        end
      end

      def container
        Dry::System::Container.new
      end
    end
  end
end

   # configure do |config|
    #   config.name = :options
    #   config.default_namespace = :options
    #   config.root = Pathname.pwd.join(top_dir).realpath.dirname.freeze
    #   config.auto_register = %w[ ]
    # end
    # load_paths! "lib", "system"