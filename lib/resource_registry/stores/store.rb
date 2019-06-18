module ResourceRegistry
  module Stores
    class Store

      store_dir           = './lib/resource_registry/stores'

      def initialize
      end

      class << self
        def store_set
          @store_set ||= StoreSet.new
        end

      end

    end

    class StoreSet
      def initialize
        @stores = Set.new
        add_store(store_files)
      end

      def store_files
        # namespace = ResourceRegistry.module_parent_for(self)
        # dir_base = ResourceRegistry.gem_file_path_for(namespace)

        store_file_pattern  = '*_store.rb'

        namespace = ResourceRegistry.module_parent_for(self.class)
        dir_base  = ResourceRegistry.gem_file_path_for(namespace)

        ResourceRegistry.file_kinds_for(file_pattern: store_file_pattern, dir_base: dir_base)
      end

      def add_store(stores)
        @stores += stores 
      end
    end
  end
end