require "dry-auto_inject"
# require 'resource_registry/services/create_repository'

module ResourceRegistry
  module Services
    class CreateOptionRepository
      include Service

      # Provide helpers for registering and accessing repository-based dependency injection
      OPTION_AUTO_INJECT = Dry::AutoInject(@repository)

      attr_reader :repository

      def call(**params)

        load_application_boot_configuration
        load_option_configuration

        repository
      end
      
      def repository
        @repository ||= CreateRepository.new.call(top_namespace: :option_repository)
      end

      private

      def load_application_boot_configuration
        LoadApplicationBootConfiguration.new.call(repository: repository)
      end

      def load_option_configuration
        LoadOptionConfiguration.new.call(repository: repository)
      end

    end
  end
end
