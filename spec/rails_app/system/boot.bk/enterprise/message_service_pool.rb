RailsApp::Registry.boot(:message_service_pool) do

  init do
    # Sneakers top level configuration
    # require 'enterprise/message_service_pool'

    # register('enterprise.message_service_pool', Enterprise::MessageServicePool.configure(ENV['ENTERPRISE_MESSAGE_SERVICE_BROKER_URL']))
  end

  start do
    # message_service_pool.establish_connection
  end

  stop do
    # message_service_pool.close_connection
  end
end