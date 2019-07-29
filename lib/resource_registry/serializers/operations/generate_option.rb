module ResourceRegistry
  module Serializers
    module Operations
      class GenerateOption < Operation

        def call(input)
          yaml = input.to_yaml
          yaml ? Success(yaml) : Failure(yaml)
        end

      end
    end
  end
end