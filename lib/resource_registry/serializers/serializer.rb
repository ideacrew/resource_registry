module ResourceRegistry
  module Serializers
    class Serializer

      DIR_BASE      = './lib/resource_registry/stores/serializers'
      FILE_PATTERN  = '*_serializer.rb'

      # serialze input string into format
      def generate
      end

      # deserialize formatted input into a string
      def parse
      end

      class << self
        def serializers
          ResourceRegistry.file_kinds_for(FILE_PATTERN, DIR_BASE)
        end

      end
    end
  end
end
