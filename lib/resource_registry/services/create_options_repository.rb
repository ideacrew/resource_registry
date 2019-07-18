module ResourceRegistry
  module Services
    class CreateOptionsRepository
      include ResourceRegistry::Service
      
      attr_reader :repository

      def call(**params)
        @repository = create_repository

        execute

        @repository
      end

      def execute
        register_stores
        register_serializers

        # load_application_boot_configuration        
        load_options_configuration
      end

      private

      def create_repository
        CreateRepository.call(top_namespace: :options_repository)
      end

      def register_stores
        @repository.register :file_store, ResourceRegistry::Stores::FileStore.new
      end

      def register_serializers
        @repository.register :xml_serializer, ResourceRegistry::Serializers::XmlSerializer.new
        @repository.register :yaml_serializer, ResourceRegistry::Serializers::YamlSerializer.new
        @repository.register :options_serializer, ResourceRegistry::Serializers::OptionsSerializer.new
      end

      def load_application_boot_configuration
        LoadApplicationBootConfiguration.call(repository: @repository)
      end

      def load_options_configuration
        LoadOptionsConfiguration.call(repository: @repository)
      end
    end
  end
end
