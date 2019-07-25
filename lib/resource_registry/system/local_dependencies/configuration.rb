require "yaml"

module ResourceRegistry
  class Configuration < Dry::Struct
    transform_keys(&:to_sym)

    attribute :tenent_key,            Types::RequiredString
    attribute :session_secret,        Types::RequiredString
    attribute :canonical_domain,      Types::String

    attribute :aws_access_key_id,     Types::String
    attribute :aws_secret_access_key, Types::String
    attribute :aws_bucket,            Types::String
    attribute :aws_region,            Types::String

    attribute :ga_tracking_id,        Types::String

    def self.load_attr(root, name)
      # TODO - change this to our serialization/store model

      path = root.join("config").join("#{name}.yml").realpath
        yaml = File.exist?(path) ? YAML.load_file(path) : {}

      dict = schema.keys.each_with_object({}) { |key, memo|
        value = yaml.dig(key.name.to_s) 
        memo[key.name.to_sym] = value
      }

      send(:new, dict)
    end

  end
end