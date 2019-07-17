module ResourceRegistry
  module Services
    class LoadOptionConfiguration
      attr_reader :repository
      include ResourceRegistry::Service
      include ResourceRegistry::Config['store', 'parser', 'auto_load_path'] if defined? ResourceRegistry::Config

      def call(**params)
        @repository = params[:repository]
        register_applications
        @repository
      end

      def register_applications
        load_option_sources
        build_options_models
        create_options_containers
      end

      def load_option_sources
        options_sources ||= []

        Dir.glob(File.join(Rails.root.to_s + "/#{auto_load_path}/*")).each do|path|
           options_sources << serializer.new(path)
        end

        @options_hash = options_sources.collect(&:load!)
      end

      def build_options_models
        @options_models = @options_hash.collect do |hash|
          serializer.__convert(result: hash['namespace'])
        end
      end

      def create_options_containers
        containers = @options_models.collect(&:to_container)
        containers.each(&@repository.method(:merge))
      end
      
      private

      def serializer
        @serializer ||= case parser
        when :yaml
          ResourceRegistry::Stores::Serializers::YamlSerializer
        when :xml
          ResourceRegistry::Stores::Serializers::XmlSerializer
        when :hash
          ResourceRegistry::Stores::Serializers::HashSerializer
        end
      end
    end
  end
end