module ResourceRegistry
  module Serializers
    class OptionGenerate
      include ResourceRegistry::Services::Service
      # include ResourceRegistry::PrivateInject["option_hash.validate"]

      def call(params)
        execute(params)
      end

      def execute(option_hash)
        schema = ResourceRegistry::Options::Validation::OptionContract.new
        result = schema.call(option_hash)
        if result.success?
          ResourceRegistry::Entities::Option.new(result.to_h)
        else
          raise InvalidOptionHash, "result.errors"
        end
      end
    end
  end
end