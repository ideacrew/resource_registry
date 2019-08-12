module ResourceRegistry
  module Serializers
    module Operations
      class GenerateEntity
        
        include Dry::Transaction::Operation

        def call(input)
          entity_hash = {}
          entity = convert(input)
          binding.pry
          return Success(entity)
        end

        private
      

        def convert(input)
          hash = {}
          if entity_types.include?(input[:key])
            hash[input[:key]] = input[:namespaces].inject({}) do |data, ns|
              data[ns[:key]] = ns[:namespaces].collect{|sub_ns| convert(sub_ns) } if ns[:namespaces]
              data
            end if input[:namespaces]
            # {convert(input[:namespaces]) if input[:namespaces] #.collect{|ns| convert(ns) } if input[:namespaces]
          else
            hash[:key] = input[:key]
            input[:settings].each {|s| hash[s[:key]] = s[:default] } if input[:settings]
            input[:namespaces].each do |ns|
              hash[ns[:key]] = ns[:namespaces].collect{|sub_ns| convert(sub_ns) } if ns[:namespaces]
            end if input[:namespaces]
          end
          hash
        end

        # def convert(input)
        #   if entity_types.include?(input.key)
        #     entity_class = entity_class_for(input.key)
        #     entity = entity_class.new
        #   end

        #   input.namespaces.each do |namespace|
        #     build_entity(entity, namespace)
        #   end

        #   entity
        # end

        # def build_entity(parent, input, entity_key = nil)
        #   if entity_types.include?(input.key)
        #     entity_key = input.key
        #   else
        #     entity_class = entity_class_for(entity_key)
        #     entity = entity_class.new(entity_attributes(input))
        #     entities  = [entity]
        #     entities += parent.send("#{entity_key}") if parent.send("#{entity_key}").present?
        #     # binding.pry

        #     parent.send("#{entity_key}=", entities)
        #   end

        #   input.namespaces.each {|namespace| build_entity(parent, namespace, entity_key) }
        # end

        def entity_types
          [:enterprise, :tenants, :sites, :features]
        end

        # def entity_attributes(input)
        #   attrs = {key: input.key}
        #   input.settings.each {|setting| attrs[setting.key] = setting.default }
        #   attrs
        # end

        # def entity_class_for(key)
        #   "ResourceRegistry::Entities::#{key.to_s.classify}".constantize
        # end
      end
    end
  end
end