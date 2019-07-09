require 'json'

module ResourceRegistry
  module Options
    class Option < Dry::Struct 
      transform_keys(&:to_sym)

      # A key with no correspnding option is a namespace
      attribute :key?,           Types::Symbol
      attribute :type?,          Types::Symbol
      attribute :default?,       Types::String
      attribute :value?,         Types::String
      attribute :title?,         Types::String
      attribute :description?,   Types::String
      attribute :options?,       Types::Array.of(Options::Option)

      def initialize(params)
        # Set nil value attribute to default 
        if params[:default] != nil && params[:value] == nil
          puts params['default']
        end

        super
      end

      def load!(ns)
        if options.present?
          ns.namespace(key) do |option_ns|
            options.each {|option| option.load!(option_ns) }
          end
        else
          ns.register(key, default)
        end
      end
    end
  end
end