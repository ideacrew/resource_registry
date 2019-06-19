module ResourceRegistry
  module Stores
    module Serializers
      class Serialzer

        DIR_BASE      = './lib/resource_registry/stores/serializers'
        FILE_PATTERN  = '*_serializer.rb'

        def initialize
        end

        class << self
          def serializers
            ResourceRegistry.file_kinds_for(FILE_PATTERN, DIR_BASE)
          end

        end
      end
    end
  end
end
