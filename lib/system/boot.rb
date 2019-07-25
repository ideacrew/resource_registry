# Initialize container with core system settings
require 'dry/system/container'

module ResourceRegistry

  class CoreContainer < Dry::System::Container

    configure do |config|
      config.name = :core
      config.default_namespace = :core
      config.root = Pathname.pwd.join('lib').realpath.freeze
      config.system_dir = "system"

      config.auto_register = %w[resource_registry/serializers resource_registry/stores]
    end

    load_paths!('system', 'resource_registry')
  end

  require_relative "local/core_options"
  CoreContainer.namespace(:options) do |container|
    path  = container.config.root.join(container.config.system_dir)
    obj   = CoreOptions.load_attr(path, "core_options")

    obj.to_hash.each_pair { |key, value| container.register("#{key}".to_sym, "#{value}") }
  end

  require_relative "local/core_inject"
  require_relative "local/persistence"

  # CoreContainer.finalize!(freeze: true) # if defined? Rails && Rail.env == 'production'
end
