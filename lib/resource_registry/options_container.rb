module ResourceRegistry
  class OptionsContainer < Dry::System::Container
    # import Application::Container

    configure do |config|
      config.name = :options
      config.default_namespace = :options
      config.root = Pathname(__FILE__).realpath.dirname.freeze
      config.auto_register = %w[
        serializers
        stores
        services       
      ]

        # lib/main/operations
        # lib/main/persistence
        # lib/main/validation
        # lib/main/views
    end

    # load_paths! "lib", "system"

    require 'resource_registry/system/core'
    container.import core: ResourceRegistry::CoreContainer
  end
end
      





