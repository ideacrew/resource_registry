module ResourceRegistry
  module Serializers
    module Operations
      class GenerateOption
        
        include Dry::Transaction::Operation

        def call(input)
          option = ResourceRegistry::Entities::Option.new(input)
          return Success(option)
        end

        private

        # def convert(input: nil)
        #   input.symbolize_keys!

        #   ResourceRegistry::Entities::Option.new(input)
        # end

        # def convert(result: nil, parent_node: nil)
        #   result.symbolize_keys!
        #   if result.keys.include?(:namespaces) || result.keys.include?(:settings)
        #     options = ResourceRegistry::Entities::Option.new(key: result[:key].to_sym)
        #     root = options if parent_node.blank?
        #     parent_node.namespaces = parent_node.namespaces.to_a + [options] if parent_node.present?
        #     [:namespaces, :settings].each do |attrs|
        #       result[attrs].each {|element| convert(result: element, parent_node: options) } if result[attrs].present?
        #     end
        #   else
        #     result.tap do |attrs|
        #       attrs[:key] = attrs[:key].to_sym
        #       attrs[:default] = attrs[:default]
        #       attrs[:value] = attrs[:value] if attrs[:value].present?
        #     end
        #     # # setting  = ResourceRegistry::Entities::Setting.new(result)
        #     # parent_node.settings = parent_node.settings.to_a + [setting]
        #   end
        #   root
        # end
      end
    end
  end
end