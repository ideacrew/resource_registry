module ResourceRegistry
  module Services
    class CreateOptionRepository
      include ResourceRegistry::Service

      # Provide helpers for registering and accessing repository-based dependency injection
      OPTION_AUTO_INJECT = Dry::AutoInject(@repository)

      attr_reader :repository
      
      def call(**params)
        create_options = self
        create_options.load
        create_options.repository
      end

      def load
        # load_application_boot_configuration 
        load_option_configuration
      end
      
      def repository
        @repository ||= CreateRepository.call
      end

      private

      def load_application_boot_configuration
        LoadApplicationBootConfiguration.new.call(repository: repository)
      end

      def load_option_configuration
        LoadOptionConfiguration.call(repository: repository)
      end
    end
  end
end
