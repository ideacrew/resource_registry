module ResourceRegistry
  module Stores
    class PersistOptions

      include AutoInject["options_validate", "options_persist"]

      attr_reader :params


      def initialize(params: {})
        @params = params
      end

      def call
        @tenant_key = params[:tenant_key]
        @file_name  = params[:file_name]
        @content    = params[:content]

        execute
      end


# File of DB?  What Store?
# Serialized_as?




      def self.load_files(*files)

        [files].flatten.compact.uniq.each do |file|
          option_repository.add_source!(file.to_s)
        end

        option_repository.load!
      end



      private

      def execute
        if File.writeable?(@file_name)
        else
          raise ResourceRegistry::Error, "Insufficient privilege to write file: #{@file_name}"
        end

        version_file if File.exist?(@file_name)


        File.open(@file_name, "w") { |file| file.write(@content) }
      end


      def version_file
        modification_time = File.mtime(@file_name)
      end

    end
  end
end