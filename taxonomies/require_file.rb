# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Operations
      class RequireFile

        include Dry::Transaction::Operation

        def call(path)
          Kernel.send(:load, path)
          Success(path)
        end
      end
    end
  end
end
