# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Registry
      extend Dry::Initializer
      
      option :config do
        option :name, type: Dry::Types["coercible.string"]
        option :root, type: ResourceRegistry::Types::Path
        option :default_namespace, type: Dry::Types["coercible.string"], optional: true
        option :system_dir,        type: Dry::Types["coercible.string"], optional: true
        option :load_path,         type: Dry::Types["coercible.string"], optional: true
        option :auto_register,     type: Dry::Types["coercible.string"], optional: true
      end
      
      option :env,       type: Dry::Types["coercible.string"], optional: true
      option :timestamp, type: Dry::Types["coercible.string"], optional: true
    end
  end
end