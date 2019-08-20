module ResourceRegistry
  module Stores
    module Operations
      class PersistFile

        include Dry::Transaction::Operation

        def call(input, file_name)
          result = File.open(file_name, "w") { |file| file.write(input) }
          return Success(result)
        end
      end
    end
  end
end