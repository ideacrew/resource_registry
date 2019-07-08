Dry::Types.load_extensions(:maybe)

module ResourceRegistry
  module Types
    include Dry::Types()

    # Expects input formatted as: { days: 60 }, { months: 6 }
    Duration = Hash.with_type_transform do |key| 
      key = key.to_sym
      unless [:hours, :days, :weeks, :months].includes? key
        raise Dry::Types::UnknownKeysError, "unexpected key [#{key}] in Hash input"
      end
    end.with_type_transform { |type| type.required(false) }.schema(length: Integer)

    Email = String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)
  end
end