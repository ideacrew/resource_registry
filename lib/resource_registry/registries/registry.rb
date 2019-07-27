require 'dry/system/container' unless defined? Dry::System::Container

module ResourceRegistry
  module Registries
    class Registry < Dry::System::Container

      use :bootsnap
      use :env, inferrer: -> { ENV.fetch("RAILS_ENV", :development).to_sym }

      def self.build(params)

      end


      # defined?(Rails) ? top_dir = '' : top_dir = 'lib'

      # configure do |config|
      #   config.name = :options
      #   config.default_namespace = :options
      #   config.root = Pathname.pwd.join(top_dir).realpath.dirname.freeze
      #   config.auto_register = %w[ ]
      # end

      # load_paths! "lib", "system"

      # require 'resource_registry/system/core'
      # container.import core: ResourceRegistry::CoreContainer

    end
  end
end