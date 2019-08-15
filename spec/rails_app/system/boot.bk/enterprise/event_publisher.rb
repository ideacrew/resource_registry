RailsApp::Registry.boot(:event_publisher) do |registry|

  init do
    use 'enterprise.message_service_pool'

    registry.register :enterprise do
      registry[:message_service_pool].command(:event_publisher)[:initialize_service]
    end
    # register(:enterprise_logger, Logger.new(registry[], ENV['ENTERPRISE_LOGGER_URL']))
  end

  start do
  end

  stop do
  end

end