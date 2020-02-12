# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features

      # Enable a Feature
      class Enable
        send(:include, Dry::Monads[:result, :do])

        def call(params)
        end
        
      end
    end
  end
end