# frozen_string_literal: true

module ResourceRegistry
  module Stores
    module File
      class ListPath

        send(:include, Dry::Monads[:result, :do])

        def call(dir)
          paths = ::Dir[::File.join(dir, '**', '*') ].reject { |p| ::File.directory? p }
          Success(paths)
        end
      end
    end
  end
end
