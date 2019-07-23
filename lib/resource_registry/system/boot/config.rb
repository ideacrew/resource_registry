Application::Container.finalize(:config) do |container|
  require "application/config"
  container.register "config", Application::Config.load(container.root, "application", container.config.env)
end
