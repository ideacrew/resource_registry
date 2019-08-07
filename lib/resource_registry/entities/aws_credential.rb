module ResourceRegistry
  module Entities
    class AwsCredential < Dry::Struct
      transform_keys(&:to_sym)

      attribute :aws_access_key_id,     Types::String
      attribute :aws_secret_access_key, Types::String
      attribute :aws_region,            Types::String

    end
  end
end