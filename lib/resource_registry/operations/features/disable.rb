# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features

      # Disable a Feature
      class Disable
        send(:include, Dry::Monads[:result, :do])

        def call(params)
        end
        
      end
    end
  end
end