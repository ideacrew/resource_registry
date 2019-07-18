module ResourceRegistry
  module Services
    class LoadOptionConfiguration      
      include ResourceRegistry::Service
      include ResourceRegistry::Config['auto_load_path'] if defined? ResourceRegistry::Config
      # include ResourceRegistry::Services::CreateOptionRepository.repository['file_store', 'serializer', 'options_serializer'] if defined? ResourceRegistry::Services::CreateOptionRepository.repository

      def call(**params)
        @repository = params[:repository]
        load_options
        @repository
      end

      def load_options
        Dir.glob(File.join(Rails.root.to_s + "/#{auto_load_path}/*")).collect do |file_path|
          content = file_store.call(content: file_path, action: :load)
          options_hash = serializer.call(content: content, action: :parse)
          options_struct = options_serializer.call(content: options_hash, action: :generate)
          @repository.persist(options_struct.to_container)
        end
      end

      private

      def file_store
        ResourceRegistry::Stores::FileStore
      end

      def serializer
        ResourceRegistry::Serializers::YamlSerializer
      end

      def options_serializer
        ResourceRegistry::Serializers::OptionsSerializer
      end
    end
  end
end