# frozen_string_literal: true

module ResourceRegistry
  module Registries
    module Operations
      class CreateContainer

        include Dry::Transaction::Operation

        def call(_input = nil)
          container = Class.new(Dry::System::Container)

          Success(container)
        end
      end
    end
  end
end