module ResourceRegistry
  module Serializers
    class OptionGenerate
      include ResourceRegistry::Services::Service
      # include ResourceRegistry::PrivateInject["option_hash.validate"]

      def call(**params)
        execute(params)
      end

      def execute(option_hash)

        parse_hash(option_hash)
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

      def parse_hash(hash_tree, ns_stack = [], namespaces = [], settings = [])
        option_list = []

        hash_tree.each_pair do |key, nodes|
          case key
          when :namespace
            ns_stack = []
            ns_stack.push key.to_s
            nodes.delete(:key)

          when :namespaces
            option_list << nodes.reduce([]) do |list, node|
              ns_stack.push key.to_s
              node.delete(:key)
              node.reduce([]) do |list, child_node|
                parse_hash(child_node, ns_stack, namespaces, settings)
                hash_tree.delete(key)
              end
binding.pry
              full_namespace = ns_stack.join('.')
              list << ResourceRegistry::Entities::Option.new(key: full_namespace, namespaces: namespaces, settings: settings)
binding.pry
              nodes.delete(:key)
              settings    = []
              namespaces  = []
            end

binding.pry
          when :settings
            nodes.reduce([]) do | list, setting_hash | 
              list << ResourceRegistry::Entities::Setting.new(setting_hash)
            end

            # hash_tree.delete(:settings)
            # parse_hash(hash_tree, ns_stack, namespaces, settings)
          end

          option_list

        end
      end



    end
  end
end