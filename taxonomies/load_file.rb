# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Operations
      class LoadFile

        include Dry::Transaction::Operation

        def call(input)
          Success(IO.read(File.open(input)))
        end
      end
    end
  end
end