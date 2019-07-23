require 'dry/system/container'

module ResourceRegistry
  class Container < Dry::Container
    root = Pathname(__FILE__).realpath.dirname
    require root.join("system/application/container")


    Application::Inject Application::Container

    configure do |config|
      config.root = Pathname(__FILE__).realpath.dirname.freeze

      config.default_namespace = "options"

      config.auto_register = %w[
        resource_registry/serializers
        resource_registry/stores
        resource_registry/services       
      ]

        # lib/main/operations
        # lib/main/persistence
        # lib/main/validation
        # lib/main/views
    end

    # load_paths! "lib", "system"
  end
end
      





