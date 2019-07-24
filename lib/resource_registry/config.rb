require "resource_registry/types"
require "yaml"

module ResourceRegistry
  class Config < Dry::Struct
    RequiredString = Types::Strict::String.constrained(min_size: 1)

    attribute :tenent_key, RequiredString
    attribute :session_secret, RequiredString
    attribute :canonical_domain, Types::String

    attribute :aws_access_key_id, Types::String
    attribute :aws_secret_access_key, Types::String
    attribute :aws_bucket, Types::String
    attribute :aws_region, Types::String

    attribute :ga_tracking_id, Types::String

    def self.load(root, name, env)
      path = root.join("config").join("#{name}.yml")

      yaml = File.exist?(path) ? YAML.load_file(path) : {}
      dict = schema.keys.each_with_object({}) { |key, memo|
        puts "key value: #{key.inspect} - #{key.class.name}"
        value = yaml.dig(env.to_s, key.name.to_s) 
        memo[key.name.to_sym] = value
      }

      new(dict)
    end

  end
end