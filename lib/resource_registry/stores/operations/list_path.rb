# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module Operations
      class ListPath

        include Dry::Transaction::Operation

        def call(dir)
          paths = Dir.glob(File.join(dir, "*"))
          Success(paths)
        end
      end
    end
  end
end