module ResourceRegistry
  module Entities
    module DryStructSetters

      def self.included(struct)
        struct.extend(ClassMethods)

        struct.schema.each do |attribute, type|
          DryStructSetters.define_setter_for(struct: struct, attribute: attribute, type: type)
        end
      end

      module ClassMethods
        def attributes(new_schema)
          super.tap do
            new_schema.each do |attribute, type|
              DryStructSetters.define_setter_for(struct: self, attribute: attribute, type: type)
            end
          end
        end
      end

      def self.define_setter_for(struct:, attribute:, type:)
        attribute = attribute.to_s.gsub(/\?/, '').to_sym
        setter = "#{attribute}=".to_sym
        struct.class_eval do
          unless instance_methods.include?(setter)
            define_method(setter) do |value|
              @attributes[attribute] = type.call(value)
            end

            setter
          end
        end
      end

      def load_container_for(collection, namespace)
        return if collection.blank?
        collection.each {|item| item.to_container(namespace) }
      end
    end
  end
end