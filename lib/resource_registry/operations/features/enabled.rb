# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features

      # Check whether a Feature is enabled
      class Enabled
        send(:include, Dry::Monads[:result, :do])

        def call(params)
        end
        
      end
    end
  end
end