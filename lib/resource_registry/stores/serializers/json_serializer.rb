require "json" unless defined?(JSON)

module ResourceRegistry
  module Stores
    module Serializers
      class JsonSerializer

        def parse(string)
          JSON.parse
        end

        def generate(object)
          object.to_json
        end

      end
    end
  end
end