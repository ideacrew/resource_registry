module ResourceRegistry
  module Services
    class CreateOptionRepository
      include ResourceRegistry::Service

      # Provide helpers for registering and accessing repository-based dependency injection
      # class << self
      #   attr_accessor :repository
      # end
      
      def call(**params)
        create_options = self
        # register_stores
        # register_serializers
        # self.class.repository = Dry::AutoInject(repository)
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

      def register_stores
        repository.register :file_store, ResourceRegistry::Stores::FileStore.new
      end

      def register_serializers
        repository.register :serializer, ResourceRegistry::Serializers::YamlSerializer.new
        repository.register :options_serializer, ResourceRegistry::Serializers::OptionsSerializer.new
      end
    end
  end
end
