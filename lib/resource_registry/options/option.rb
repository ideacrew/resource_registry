require 'json'

module ResourceRegistry
  module Options
    class Option < Dry::Struct 
      transform_keys(&:to_sym)

      # A key with no correspnding option is a namespace
      attribute :key?,           Types::Symbol
      attribute :type?,          Types::Symbol
      attribute :default?,       Types::String
      attribute :value?,        Types::String
      attribute :title?,        Types::String
      attribute :description?,  Types::String


      def initialize(params)
        # Set nil value attribute to default 
        if params[:default] != nil && params[:value] == nil
          puts params['default']
        end

        super
      end


# module DeepStruct

#   def to_ostruct

#     case self
#     when Hash
#       root = OpenStruct.new(self)
#       self.each_with_object(root) do |(k,v), o|
#         o.send("#{k}=", v.to_ostruct)
#       end
#       root
#     when Array
#       self.map do |v|
#         v.to_ostruct
#       end
#     else
#       self
#     end

#   end

# end


    end
  end
end