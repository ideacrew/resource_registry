# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module File
      class Require
        send(:include, Dry::Monads[:result, :do])

        def call(path)
          Kernel.send(:load, path)
          Success(path)
        end
      end
    end
  end
end
