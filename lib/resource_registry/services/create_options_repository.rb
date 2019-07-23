module ResourceRegistry
  module Services
    class CreateOptionsRepository


      attr_reader :repository

      def call(**params)
        @repository = create_repository #ResourceRegistry::OPTIONS_REPOSITORY || create_repository
        # @repository_constant_name = params[:repository_constant_name] || 'OPTIONS_REPOSITORY'
        # @injection_constant_name  = params[:injection_constant_name]  || 'OPTIONS_AUTO_INJECT'

        execute

        @repository
      end

      def setup
        @repository = create_repository
        register_stores
        register_serializers
        define_repository_constants
      end

      def execute
        # define_repository_constants
        # register_stores
        # register_serializers

        # load_application_boot_configuration        
        load_options_configuration
      end

      private

      # Initialize the repo container and set constants to access and enable dependency injection
      def create_repository
        ResourceRegistry::Repository.new
      end

      def define_repository_constants
        ResourceRegistry.const_set(:OPTIONS_REPOSITORY, @repository) unless defined? ResourceRegistry::OPTIONS_REPOSITORY
        ResourceRegistry.const_set(:OPTIONS_AUTO_INJECT, Dry::AutoInject(@repository)) unless defined? ResourceRegistry::OPTIONS_AUTO_INJECT
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
