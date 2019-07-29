module ResourceRegistry
  module Entities
    class Registry < Dry::Types::Struct

      undefined     = Types::Undefined
      nil_or_string = Types::Nil | Types::String

      # Configuration values
      attribute :config do
        attribute :name,              Types::Strict::String
        attribute :root,              Types::Strict::String
        attribute :env,               Types::Strict::String

        attribute :default_namespace, nil_or_string | undefined
        attribute :system_dir,        nil_or_string | undefined
        attribute :load_path,         nil_or_string | undefined

        # Dir, plus optional custom auto_register block
        attribute :auto_register,     Types::Array.of(nil_or_string) | undefined
      end

      attribute :timestamp,           Types::DateTime.default { DateTime.now }

      # Persistence values
      attribute :persistence do
        attribute :store,       Types::Stores
        attribute :serializer,  Types::Serializers
        attribute :container,   Types::Strict::String
      end

      # Override or additional attributes
      attribute :options,     ResourceRegistry::Entities::Option

    end
  end
end
