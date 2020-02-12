# frozen_string_literal: true

module ResourceRegistry
  module Registries
    module Operations
      class Create
        send(:include, Dry::Monads[:result, :do])

        def call(_input = nil)
          container = Class.new(Dry::System::Container)

          Success(container)
        end
      end
    end
  end
end