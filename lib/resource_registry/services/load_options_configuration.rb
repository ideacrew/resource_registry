module ResourceRegistry
  module Services
    class LoadOptionsConfiguration      
      include ResourceRegistry::Services::Service
      include ResourceRegistry::Config['seed_files_path'] if defined? ResourceRegistry::Config
      include ResourceRegistry::OPTIONS_AUTO_INJECT['file_store', 'yaml_serializer', 'options_serializer'] if defined? ResourceRegistry::OPTIONS_AUTO_INJECT

      def call(**params)
        @repository = params[:repository]
        
        execute
        
        @repository
      end

      def execute
        Dir.glob(File.join(Rails.root.to_s, seed_files_path, "*")).each do |file_path|
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
    end
  end
end