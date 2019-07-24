ResourceRegistry::Container.namespace :logger do |container|
  container.boot(:logger) do

    
  end

  # require "logger"
  # container.register :logger, Logger.new(container.root.join("log/#{container.config.env}.log"))
end
