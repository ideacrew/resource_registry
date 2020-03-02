# frozen_string_literal: true

module ResourceRegistry
  module Serializers
    module Features

      # Transform a Hash into YAML-formatted String
      class Serialize
        send(:include, Dry::Monads[:result, :do])

        def call(params)
        end

      end
    end
  end
end
