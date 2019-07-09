module ResourceRegistry
  module Services
    class LoadApplicationBootConfiguration

      attr_reader :repository

      def call(params)
        @repository       = params[:repository]
        # @message_services = params[:message_services] || []

        configure_logger
        configure_error_handler
        configure_authenticator
        # configure_message_service

        register_applications
      end

      def register_applications
        @repository.register
      end

      def configure_logger
        @repository.register(:logger) { ResourceRegistry::Boot::Logger.new }
      end

      def configure_error_handler
          @repository.register(:error_handler) do |repo|
          handler = ResourceRegistry::Boot::ErrorHandler.new
          handler.logger = repo.logger
          handler
        end
      end

      def configure_authenticator
        @repository.register(:authenticator) do |repo|
          ResourceRegistry::Boot::Authenticator.new(logger: repo.logger, error_handler: repo.error_handler)
        end
      end


      def configure_message_service
        @repository.register(:message_broker) { ResourceRegistry::Boot::MessageBroker.new }

        # unless params[:message_services] == nil
        #   @repository.namespace(:message_services) do
        #     configure_message_services
        #   end
        # end

        # @message_services.reduce({}) do |list, message_service|
        #   list.merge register("#{message_service.key}") { ResourceRegistry::Boot::MessageService.new }
        # end
      end

    end
  end
end