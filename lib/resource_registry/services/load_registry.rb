module ResourceRegistry
  module Services
    class LoadRegistry
      include ResourceRegistry::Services::Service
      include ResourceRegistry::RegistryInjector["persistence.store", "persistence.serializer"] if defined? ResourceRegistry::RegistryInjector

      def call(**params)
        Dir.glob(File.join(params[:path], "*")).each do |file_path|
          content         = store_klass.call(content: file_path, action: :load)
          options_hash    = serializer_klass.call(content: content, action: :parse)
          options_struct  = options_builder.call(content: options_hash, action: :generate)
          Registry.merge(options_struct.to_container)
        end
      end

      def store_klass
        if store == 'file_store'
          ResourceRegistry::Stores::FileStore
        end
      end

      def serializer_klass
        if serializer == 'yaml_serializer'
          ResourceRegistry::Serializers::YamlSerializer
        end
      end

      def options_builder
        ResourceRegistry::Serializers::OptionsSerializer
      end
    end
  end
end