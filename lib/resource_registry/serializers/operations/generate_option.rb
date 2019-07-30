module ResourceRegistry
  module Serializers
    module Operations
      class GenerateOption
        
        include Dry::Transaction::Operation

        def call(input)
          option = convert(result: input)
          return Success(option)
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
      end
    end
  end
end