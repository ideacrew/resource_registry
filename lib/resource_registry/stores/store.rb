module ResourceRegistry
  module Stores
    class Store

      attr_accessor :tenant, :configuration_set_name, :configuration_set

      def load
      end

      def persist
      end

    end

    class StoreSet
      attr_reader :stores

      def initialize
        @stores = Set.new
        add_store(store_files)
      end

      def store_files
        namespace = ResourceRegistry.module_parent_for(self.class)
        store_dir = ResourceRegistry.gem_file_path_for(namespace)
        store_file_pattern  = '*_store.rb'

        ResourceRegistry.file_kinds_for(file_pattern: store_file_pattern, dir_base: store_dir)
      end

      def add_store(stores)
        @stores += stores
      end
    end
  end
end
