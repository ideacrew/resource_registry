module ResourceRegistry
  module Entities
    class Registry < Dry::Types::Struct

      Serializers   = Types::String.enum('yaml_serializer').default('yaml_serializer'.freeze)
      Stores        = Types::String.enum('file_store').default('file_store'.freeze)
      undefined     = Types::Undefined
      nil_or_string = Types::Nil | Types::String

      # Configuration values
      attribute :registry_name,     Types::Strict::String
      attribute :root,              Types::Strict::String
      attribute :name,              nil_or_string | undefined
      attribute :default_namespace, nil_or_string | undefined
      attribute :app_name,          nil_or_string | undefined
      attribute :env,               nil_or_string | undefined
      attribute :system_dir,        nil_or_string | undefined
      attribute :load_paths,        Types::Array.of(nil_or_string) | undefined

      # Dir, plus optional custom auto_register block
      attribute :auto_register,     Types::Array.of(nil_or_string) | undefined 

      # Persistence values
      attribute :store,       Stores
      attribute :serializer,  Serializers
      attribute :container,   Types::Strict::String

      # Override or additional attributes
      attribute :options,     ResourceRegistry::Entities::Options
      attribute :timestamp,   Types::DateTime.default { DateTime.now }

    end
  end
end
