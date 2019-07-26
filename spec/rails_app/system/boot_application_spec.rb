# require 'resource_registry/boot/logger'
# require 'resource_registry/boot/error_handler'
# require 'resource_registry/boot/authenticator'
# require 'resource_registry/boot/message_broker'
# require 'resource_registry/boot/message_service'

# # installation
# # installation has_many installation_accounts
# # installation has_one installation owner_account
# # installation has_one core_service_set
# #   core_service_set has_one authenticator
# #   core_service_set has_one error_handler
# #   core_service_set has_one logger
# #   core_service_set has_one message_broker
# # installation has_many disaster_recovery_sites
# # installation has_many tenants
# #   tenant has_one site
# #     site has_many site_accounts
# #     site has_one site owner_account
# #     site has_many environments
# #     environment has_many applications
# #       application has_one settings_repository
# #       application has_one portal
# #       application has_many message_services
# #       application has_many features
# #       applicagion has_many instrumentation_monitors


# module ResourceRegistry
#   class BootApplication

#     attr_reader :repository, :message_services

#     def call(params)
#       @repository = params[:repository]

#       initialize_logger
#       initialize_error_handler
#       initialize_authenticator
#       initialize_message_broker
#       initialize_configuration

#       unless params[:message_services] == nil
#         @repository.namespace(:message_services) do
#           initialize_message_services
#         end
#       end
#     end

#     def initialize_configuration
      
#     end

#     def initialize_logger
#       @repository.register(:logger) { ResourceRegistry::Boot::Logger.new }
#     end

#     def initialize_error_handler
#         @repository.register(:error_handler) do |repo|
#         handler = ResourceRegistry::Boot::ErrorHandler.new
#         handler.logger = repo.logger
#         handler
#       end
#     end


#     def initialize_authenticator
#       @repository.register(:authenticator) do |repo|
#         ResourceRegistry::Boot::Authenticator.new(logger: repo.logger, error_handler: repo.error_handler)
#       end
#     end


#     def initialize_message_broker
#       @repository.register(:message_broker) { ResourceRegistry::Boot::MessageBroker.new }
#     end


#     def initialize_message_services
#       @message_services.reduce({}) do |list, message_service|
#         list.merge register("#{message_service.key}") { ResourceRegistry::Boot::MessageService.new }
#       end
#     end

#   end
# end