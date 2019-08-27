# frozen_string_literal: true

module ResourceRegistry
  module Entities
    class Registry
      extend Dry::Initializer
      
      option :config do
        option :name
        option :root
        option :default_namespace, optional: true
        option :system_dir,        optional: true
        option :load_path,         optional: true
        option :auto_register,     optional: true
      end
      
      option :env,       optional: true
      option :timestamp, optional: true
    end
  end
end