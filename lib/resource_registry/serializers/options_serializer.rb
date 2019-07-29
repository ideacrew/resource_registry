module ResourceRegistry
  module Serializers
    class OptionsSerializer
      include ResourceRegistry::Services::Service

      def call(**params)
        @content = params[:content]
        @action  = params[:action]

        send(@action)
      end

      def parse
      end

      def generate
        raise InvalidOptionHash if @content['namespace'].blank?
        convert(result: @content['namespace'])
      end

      private

      def convert(result: nil, parent_node: nil)
        result.symbolize_keys!

        if result.keys.include?(:namespaces) || result.keys.include?(:settings)
          options = ResourceRegistry::Entities::Option.new(key: result[:key].to_sym)
          root = options if parent_node.blank?
          parent_node.namespaces = parent_node.namespaces.to_a + [options] if parent_node.present?
          [:namespaces, :settings].each do |attrs|
            result[attrs].each {|element| convert(result: element, parent_node: options) } if result[attrs].present?
          end
        else
          result.tap do |attrs|
            attrs[:key] = attrs[:key].to_sym
            attrs[:default] = attrs[:default].to_s
            attrs[:value] = attrs[:value].to_s if attrs[:value].present?
          end
          setting  = ResourceRegistry::Entities::Setting.new(result)
          parent_node.settings = parent_node.settings.to_a + [setting]
        end

        root
      end

      # def descend_array(array) #:nodoc:
      #   array.map do |value|
      #     if value.instance_of? ResourceRegistry::Entities::Options
      #       value.to_hash
      #     elsif value.instance_of? Array
      #       descend_array(value)
      #     else
      #       value
      #     end
      #   end
      # end
    end
  end
end