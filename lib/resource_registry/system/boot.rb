# Initialize container with core system settings

require 'dry/system/container'

module ResourceRegistry
  class CoreContainer < Dry::System::Container

    configure do |config|
      config.name = :core
      config.default_namespace = :core
      config.root = Pathname(__FILE__).join("..").realpath.dirname.freeze
      # config.system_dir = "system"

      # Dir relative to root where bootable components are defined
      # config.system_dir = "system"

      config.auto_register = %w[serializers stores]
    end

  # load_paths! "system/local_dependencies"
  end

  require_relative "local_dependencies/configuration"
  CoreContainer.namespace(:config) do |container|
    path = container.config.root.join(container.config.system_dir)
    container.register :config, Configuration.load_attr(path, "config")
  end


  require_relative "local_dependencies/persistence"

  ## TODO -- this is where we incorporate local application config settings
  # system_paths = Pathname(__FILE__).dirname.join("../../resource_registry").realpath
  # Dir[system_paths].each do |f|
  #   require "#{f}/system/boot"
  # end

end
