Application::Container.namespace :message_service do |container|
  container.boot :message_service do

    # require "que"

    # uses :logger
    # container.boot :rom

    # container.register :connection, container["persistence.config"].gateways[:default].connection

    # Que.logger = logger
    # Que.mode = :sync if container.config.env == :test
    # Que.connection = container["que.connection"]

  end
end