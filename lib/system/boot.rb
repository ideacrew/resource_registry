# Initialize container with core system settings
module ResourceRegistry

  require_relative 'boot/container'
  
  require "resource_registry/entities/core_options"
  
  CoreContainer.namespace(:options) do |container|
    path  = container.config.root.join(container.config.system_dir)
    obj   = ResourceRegistry::Entities::CoreOptions.load_attr(path, "core_options")
    obj.to_hash.each_pair { |key, value| container.register("#{key}".to_sym, "#{value}") }
  end

  require_relative "local/core_inject"
  require_relative "local/persistence"

  # CoreContainer.finalize!(freeze: true) # if defined? Rails && Rail.env == 'production'
end
