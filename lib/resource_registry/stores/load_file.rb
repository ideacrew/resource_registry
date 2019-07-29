module ResourceRegistry
  module Stores
    class LoadFile

      include Dry::Transaction::Operation

      def call(input)
        return Success(IO.read(File.open(input)))
      end
    end
  end
end