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
      include ResourceRegistry::Services::Service

      # use :bootsnap
      # use :env, inferrer: -> { ENV.fetch("RAILS_ENV", :development).to_sym }

      def call(**params)
        @params     = params[:result]
        @container  = create_container

        set_config
        # set_load_paths # FIX ME

        @container
      end

      def set_config
        @container.configure do |config|
          @params[:config].each_pair do |key, value|
            config.send "#{key}=", value
          end
        end
      end

      def set_load_paths
        @container.send :load_paths!, @params[:load_paths]
      end

      def create_container
        return @container if defined? @container
        @container = Class.new(Dry::System::Container)
      end
    end
  end
end