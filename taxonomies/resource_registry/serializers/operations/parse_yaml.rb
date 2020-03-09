# frozen_string_literal: true

require 'yaml'

module ResourceRegistry
  module Serializers
    module Operations
      class ParseYaml

        include Dry::Transaction::Operation

        # rubocop:disable Security/YAMLLoad
        def call(input)
          Success(YAML.load(input))
        end
        # rubocop:enable Security/YAMLLoad
      end
    end
  end
end