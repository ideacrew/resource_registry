require 'dry/system/container'

# Sample params
# configure do |config|
#   config.name = :options
#   config.default_namespace = :options
#   config.root = Pathname.pwd.join(top_dir).realpath.dirname.freeze
#   config.auto_register = %w[ ]
# end
# load_paths! "lib", "system"

module ResourceRegistry
  module Registries
    class Registry

      # use :bootsnap
      # use :env, inferrer: -> { ENV.fetch("RAILS_ENV", :development).to_sym }

      def initialize(validation)
        @validation = validation
        @container  = container
      end

      def load
        set_config
        # set_load_paths 
        set_persistence
        # set_environment
      end

      def set_config
        configure do |container|
          @validation.output[:config].each_pair do |key, value|
            container.configure do |config|
              config.send "#{key}=", value
            end
          end
        end
      end

      def configure
        yield(@container)
      end

      def set_load_paths
        @container.send :load_paths!, @validation.output[:load_paths]
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
        return @container if defined? @container
        @container = Dry::System::Container
      end

      def self.call(validation)
        registry = self.new(validation)
        registry.load
        registry.container
      end
    end
  end
end