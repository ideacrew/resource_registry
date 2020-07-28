# frozen_string_literal: true

module ResourceRegistry
  module Serializers
    module Operations
      class GenerateYaml < Operation

        def call(input)
          yaml = input.to_yaml
        end

      end
    end
  end
end
