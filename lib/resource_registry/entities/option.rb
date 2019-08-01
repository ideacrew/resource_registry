require 'resource_registry/entities/setting'

module ResourceRegistry
  module Entities
    OptionConstructor = Types.Constructor("Option") { |val| Option.new(val) rescue nil }

    class Option
      extend Dry::Initializer
      include Enumerable
      option :namespace,   type: Dry::Types["coercible.symbol"], optional: true
      option :key,          type: Dry::Types["coercible.symbol"], optional: true

      # TODO: Make settings attribute dynamically typed
      option :settings, type: Dry::Types['coercible.array'].of(SettingConstructor), optional: true, default: -> { [] }
      option :namespaces, Dry::Types['coercible.array'].of(OptionConstructor), optional: true, default: -> { [] }

      def each
        settings.each do |s|
          yield s
        end

       namespaces.each do |ns|
          yield ns
        end
      end
    end
  end
end