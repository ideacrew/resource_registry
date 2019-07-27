require 'dry-types'
Dry::Types.load_extensions(:maybe)

module ResourceRegistry
  module Types
    include Dry::Types()

    Serializers     = Types::String.default('yaml_serializer'.freeze).enum('yaml_serializer', 'xml_serializer')
    Stores          = Types::String.default('file_store'.freeze).enum('file_store')

    RequiredString  = Types::Strict::String.constrained(min_size: 1)
    Email           = String.constrained(format: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i)

    # Expects input formatted as: { days: 60 }, { months: 6 }
    Duration = Hash.with_type_transform do |key| 
      key = key.to_sym
      unless [:hours, :days, :weeks, :months].includes? key
        raise Dry::Types::UnknownKeysError, "unexpected key [#{key}] in Hash input"
      end
    end.with_type_transform { |type| type.required(false) }.schema(length: Integer)
    
  end
end