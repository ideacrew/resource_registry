module ResourceRegistry
  module Serializers
    class OptionGenerate
      include ResourceRegistry::Services::Service
      # include ResourceRegistry::PrivateInject["option_hash.validate"]

      def call(**params)
        execute(params)
      end

      def execute(option_hash)

        parse_hash(option_hash: option_hash)
binding.pry
        result = option_hash.validate

        if result.success?
          parse_hash(option_hash)
        else
          # raise InvalidOptionHash if @content['namespace'].blank?
          raise InvalidOptionHash, "result.errors"
        end
      end


      private

      def parse_hash(hash_obj, ns_stack = [], namespaces = [], settings = [])

        hash_obj.each_pair do |key, value|
          case key
          when :namespace
            ns_stack = []
            ns_stack.push value.delete(:key).to_s

            parse_hash(value, ns_stack, namespaces, settings)
            option_obj = ResourceRegistry::Entities::Option.new(key: ns_stack, namespaces: namespaces, settings: settings)

          when :namespaces
            namespaces = hash_obj.map do |ns|
              ns_stack.push ns.delete(:key).to_s
binding.pry
              parse_hash(ns, ns_stack, namespaces, settings)
            end

            full_namespace = ns_stack.join('.')
            namespaces << ResourceRegistry::Entities::Option.new(key: full_namespace, namespaces: namespaces, settings: settings)
            ns_stack.pop
            namespaces = []

          when :settings
binding.pry
            settings = hash_obj.reduce([]) do | list, setting_hash| 
              list << ResourceRegistry::Entities::Setting.new(setting_hash)
            end

            hash_obj.delete(:settings)
            parse_hash(hash_obj, ns_stack, namespaces, Hash.new(settings))

          end
        end
        
        option_obj

      end


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

    end
  end
end