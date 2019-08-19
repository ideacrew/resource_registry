module ResourceRegistry
  module Entities
    OptionConstructor = Types.Constructor("Option") { |val| Option.new(val) rescue nil }

    class Option
      extend Dry::Initializer

      option :namespace,      type: Dry::Types["coercible.symbol"], optional: true
      option :key,            type: Dry::Types["coercible.symbol"]     
      option :namespaces,     type: Dry::Types['coercible.array'].of(OptionConstructor), optional: true, default: -> { [] }
      
      option :settings, [], optional: true do
        option :key,          type: Dry::Types["coercible.symbol"]
        option :title,        type: Dry::Types["coercible.string"], optional: true
        option :description,  type: Dry::Types["coercible.string"], optional: true
        option :type,         type: Dry::Types["coercible.symbol"], optional: true
        option :default,      type: Dry::Types["any"]
        option :value,        type: Dry::Types["any"], optional: true
      end

      def each
        settings.each   { |setting|   yield setting }
        namespaces.each { |namespace| yield namespace }
      end
    end
  end
end