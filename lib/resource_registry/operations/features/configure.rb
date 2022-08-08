# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      class Configure
        send(:include, Dry::Monads[:result, :do])

        def call(_params)
          yield configuration
        end


      end
    end
  end
end
