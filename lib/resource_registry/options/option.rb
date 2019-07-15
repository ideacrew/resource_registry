require 'json'

module ResourceRegistry
  module Options
    class Option < Dry::Struct 
      include DryStructSetters
      transform_keys(&:to_sym)

      # A key with no correspnding option is a namespace
      attribute :key,            Types::Symbol
      attribute :title?,         Types::String
      attribute :description?,   Types::String
      attribute :type?,          Types::Symbol
      attribute :default?,       Types::String
      attribute :value?,         Types::String

      def initialize(params)
        # Set nil value attribute to default 
        if params[:default] != nil && params[:value] == nil
          puts params['default']
        end

        super
      end

      def load!(ns)
        ns.register(key, default)
      end


    end
  end
end