module ResourceRegistry
  module Stores
    class FileStore < Store

      attr_accessor :content

      def load(file_name)
        @content = File.read(source_file_name)
      end

      def persist(file_name)
        File.open(file_name, "w") { |file| file.write(@content) }
      end
      
    end
  end
end