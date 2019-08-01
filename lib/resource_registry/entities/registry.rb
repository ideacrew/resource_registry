module ResourceRegistry
  module Entities
    class Registry < Dry::Struct

      # Configuration values
      attribute :config do
        attribute :name,              Types::Strict::String
        attribute :root,              Types::Strict::String

        attribute :default_namespace, Types::NilOrString #| Types::Undefined
        attribute :system_dir,        Types::NilOrString #| Types::Undefined
        attribute :load_path,         Types::NilOrString #| Types::Undefined

        # Dir, plus optional custom auto_register block
        attribute :auto_register,     Types::Array.of(Types::NilOrString) #| Types::Undefined
      end

      attribute :env,                 Types::Strict::String
      attribute :timestamp,           Types::DateTime.default { DateTime.now }
    end
  end
end
