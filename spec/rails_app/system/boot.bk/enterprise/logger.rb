# frozen_string_literal: true

RailsApp::Registry.boot(:logger) do |registry|

  start do
    use 'enterprise.message_service_pool'

    registry.register :enterprise do
      registry[:message_service_pool].command(logger)[:initialize_service]
    end
  end

end