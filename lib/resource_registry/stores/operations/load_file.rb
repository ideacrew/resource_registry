module ResourceRegistry
  module Stores
    module Operations
      class LoadFile

        include Dry::Transaction::Operation

        def call(input)
          return Success(IO.read(File.open(input)))
        end
      end
    end
  end
end