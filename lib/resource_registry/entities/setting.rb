require 'resource_registry/entities/dry_struct_setters'

module ResourceRegistry
  module Entities
    class Setting
      extend Dry::Initializer

      option :key, type: Dry::Types["coercible.symbol"]
      option :title, type: Types::String, optional: true
      option :description, type: Types::String, optional: true
      option :type, type: Dry::Types["coercible.symbol"], optional: true
      option :default, type: Types::Any, optional: true
      option :value, type: Types::Any, optional: true
    end

    SettingConstructor = Types.Constructor(Setting) { |val| Setting.new(val) }
  end
end