module ResourceRegistry
  module Store
    module Serializer


      class SerilaizerSet
        attr_reader :serializers
        
        def initialize
          @serializers = Set.new
          add_serializer(serializer_files)
        end

        def serializer_files
          namespace = ResourceRegistry.module_parent_for(self.class)
          serializer_dir = ResourceRegistry.gem_file_path_for(namespace)
          serializer_file_pattern  = '*_serializer.rb'

          ResourceRegistry.file_kinds_for(file_pattern: serializer_file_pattern, dir_base: serializer_dir)
        end

        def add_serializer(serializers)
          @serializers += serializers 
        end
      end

    end
  end
end