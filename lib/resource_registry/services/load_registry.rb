module ResourceRegistry
  module Services
    class LoadRegistry
      include RegistryInjector["persistence.store", "persistence.serializer"]

      def load_options(path)
        Dir.glob(File.join(path, "*")).each do |file_path|
          content         = store.call(content: file_path, action: :load)
          options_hash    = serializer.call(content: content, action: :parse)
          options_struct  = options_builder.call(content: options_hash, action: :generate)
          Repository.merge(options_struct.to_container)
        end
      end

      def store
        if options_store == 'file_store'
          ResourceRegistry::Stores::FileStore.new
        end
      end

      def serializer
        if options_serializer == 'yaml_serializer'
          ResourceRegistry::Serializers::YamlSerializer.new
        end
      end

      def options_builder
        ResourceRegistry::Serializers::OptionsSerializer.new
      end
    end
  end
end