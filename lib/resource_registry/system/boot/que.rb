Application::Container.namespace :que do |container|
  container.finalize :que do
    require "que"

    uses :logger
    container.boot :rom

    container.register :connection, container["persistence.config"].gateways[:default].connection

    Que.logger = logger
    Que.mode = :sync if container.config.env == :test
    Que.connection = container["que.connection"]
  end
end
