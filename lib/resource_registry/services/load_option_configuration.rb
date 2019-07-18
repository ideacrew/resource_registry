module ResourceRegistry
  module Services
    class LoadOptionConfiguration      
      include ResourceRegistry::Service
      include ResourceRegistry::Config['auto_load_path'] if defined? ResourceRegistry::Config
      include OPTIONS_AUTO_INJECT.repository['file_store', 'yaml_serializer', 'options_serializer'] if defined? ResourceRegistry::Services::CreateOptionRepository.repository
      # include ResourceRegistry::OPTIONS_AUTO_INJECT.repository['file_store', 'yaml_serializer', 'options_serializer'] if defined? ResourceRegistry::Services::CreateOptionRepository.repository

      def call(**params)
        @repository = params[:repository]
        execute

        @repository
      end

      def execute
# binding.pry
        Dir.glob(File.join(root.to_s + auto_load_path)).collect do |file_path|
          content         = file_store.call(content: file_path, action: :load)
          options_hash    = yaml_serializer.call(content: content, action: :parse)
          options_struct  = options_serializer.call(content: options_hash, action: :generate)

          @repository.persist(options_struct.to_container)
        end
      end

      private

      def root
        File.dirname __dir__
      end

      def auto_load_path
        # ResourceRegistry::Config[:auto_load_path] if defined? ResourceRegistry::Config
        "spec/support"
      end

      # def file_store
      #   ResourceRegistry::Stores::FileStore
      # end

      # def serializer
      #   ResourceRegistry::Serializers::YamlSerializer
      # end

      # def options_serializer
      #   ResourceRegistry::Serializers::OptionsSerializer
      # end
    end
  end
end