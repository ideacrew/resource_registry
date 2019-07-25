require "yaml"

module ResourceRegistry
  module Entities
    class Configuration < Dry::Struct
      # transform_keys(&:to_sym)

      attribute :store,                 Types::RequiredString
      attribute :serializer,            Types::RequiredString
      attribute :seed_files_path,       Types::String

      def self.load_attr(root, name)
        # TODO - change this to our serialization/store model

        path = root.join("config").join("#{name}.yml").realpath
        yaml = File.exist?(path) ? YAML.load_file(path) : {}

        dict = schema.keys.each_with_object({}) { |key, memo|
          value = yaml.dig(key.name.to_s) 
          memo[key.name.to_sym] = value
        }

        new(dict)
      end

    end
  end
end