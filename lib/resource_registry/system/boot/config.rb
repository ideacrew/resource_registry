Application::Container.finalize(:config) do |container|
  require "resource_registry/config"
  container.register "config", ResourceRegistry::Config.load(container.root, "application", container.config.env)
end
