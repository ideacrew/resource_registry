module ResourceRegistry
  module Registries
    module Operations
      class CreateContainer

        include Dry::Transaction::Operation

        def call(input = nil)
          container = Class.new(Dry::System::Container)

          return Success(container)
        end
      end
    end
  end
end