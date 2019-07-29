module ResourceRegistry
  module Services
    class LoadRegistry
      include ResourceRegistry::Services::Service
      # include ResourceRegistry::PublicInjector["persistence.store", "persistence.serializer"] if defined? ResourceRegistry::PublicInjector

      def call(**params)
        Dir.glob(File.join(params[:path], "*")).each do |file_path|
          create_and_merge_container(file_path)
        end
      end

      def create_and_merge_container(file_path)
        content         = content_for(file_path)
        options_hash    = options_hash_for(content)
        options_struct  = options_struct_for(options_hash)
        container       = container_for(options_struct)
        Registry.merge(container)
      end

      def content_for(file_path)
        system_store.call(content: file_path, action: :load)
      end

      def options_hash_for(content)
        input_serializer.call(content: content, action: :parse)
      end

      def options_struct_for(options_hash)
        options_serializer.call(content: options_hash, action: :generate)
      end

      def container_for(options_struct)
        container_serializer.call(content: options_struct, action: :generate)
      end

      private

      def system_store
        # if store == 'file_store'
        ResourceRegistry::Stores::FileStore
        # end
      end

      def input_serializer
        # if serializer == 'yaml_serializer'
        ResourceRegistry::Serializers::YamlSerializer
        # end
      end

      def options_serializer
        ResourceRegistry::Serializers::OptionsSerializer
      end

      def container_serializer
        ResourceRegistry::Serializers::ContainerSerializer
      end
    end
  end
end