# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features

      # Create a Feature
      class Create
        send(:include, Dry::Monads[:result, :do])

        def call(params)
        end
        
      end
    end
  end
end