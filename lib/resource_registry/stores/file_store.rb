# frozen_string_literal: true

module ResourceRegistry
  module Stores
    class FileStore < Store
      # include ResourceRegistry::Services::Service

      def call(**params)
        @content = params[:content]
        @action  = params[:action]

        send(@action)
      end

      def load
        IO.read(File.open(@content))
      end

      def persist(file_name)
        File.open(file_name, "w") { |file| file.write(@content) }
      end

      def self.options_files(config_root, env)
        [
          File.join(config_root, 'options.yml').to_s,
          File.join(config_root, 'options', "#{env}.yml").to_s,
          File.join(config_root, 'environments', "#{env}.yml").to_s
        ].freeze
      end

      def load_option_sources
        options_serializers ||= []

        Dir.glob(File.join(Rails.root.to_s + "/#{seed_file_path}/*")).each do |path|
          options_serializers << serializer.new(path)
        end

        @options_hash = options_serializers.collect(&:parse)
      end
    end
  end
end