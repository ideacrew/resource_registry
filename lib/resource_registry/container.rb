require 'dry/system/container' unless defined? Dry::System::Container

module ResourceRegistry
  class Container < Dry::System::Container
    # import Application::Container

    defined?(Rails) ? top_dir = '' : top_dir = 'lib'

    configure do |config|
      config.name = :options
      config.default_namespace = :options
      config.root = Pathname.pwd.join(top_dir).realpath.dirname.freeze
      config.auto_register = %w[ ]
    end

    # load_paths! "lib", "system"

    # require 'resource_registry/system/core'
    # container.import core: ResourceRegistry::CoreContainer
  end
end
