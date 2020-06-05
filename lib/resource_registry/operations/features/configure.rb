# frozen_string_literal: true

module ResourceRegistry
  module Operations
    module Features
      class Configure
        send(:include, Dry::Monads[:result, :do])

        def call(params)
          yield configuration
        end

        private

      end
    end
  end
end
