require "resource_registry/types"
require "yaml"

module ResourceRegistry
  class Config < Dry::Types::Struct
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

      config = schema.keys.each_with_object({}) { |key, memo|
        value = ENV.fetch(
          key.to_s.upcase,
          yaml.fetch(env.to_s, {})[key.to_s]
        )

        memo[key] = value
      }

      new(config)
    end
  end
end