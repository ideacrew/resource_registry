require 'dry-struct'

Dry::Types.load_extensions(:maybe)

module ResourceRegistry
  module Types
    # include Dry.Types
    include Dry::Types.module

    Email = String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end
end