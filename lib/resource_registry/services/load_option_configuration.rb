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
        settings_hash = load_option_files
        options = convert_to_options(settings_hash)
        options.to_container(@repository)
      end

      def convert_to_options(settings_hash)
        serializer.__convert(result: settings_hash['namespace'])
      end

      def load_option_files
        @options_sources ||= []
        Dir.glob(File.join(Rails.root.to_s + "/#{auto_load_path}/*")).each do|path|
          add_source!(path.to_s)
        end
        load!
      end

      def add_source!(source)
        @options_sources << serializer.new(source)
      end

      def reload!
        conf = {}
        @options_sources.each do |source|
          source_conf = source.load!

          if conf.empty?
            conf = source_conf
          else
            DeepMerge.deep_merge!(
              source_conf,
              conf,
              preserve_unmergeables: false,
              knockout_prefix:       nil,
              overwrite_arrays:      true,
              merge_nil_values:      true
              )
          end
        end
        conf
      end

      alias :load! :reload!

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