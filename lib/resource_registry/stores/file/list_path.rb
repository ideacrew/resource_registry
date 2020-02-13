# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module File
      class ListPath

        send(:include, Dry::Monads[:result, :do])

        def call(dir)
          paths = ::Dir.glob(::File.join(dir, "*"))
          Success(paths)
        end
      end
    end
  end
end