# frozen_string_literal: true

module ResourceRegistry
  module Serializers
    module Operations
      class GenerateContainer

        include Dry::Transaction::Operation

        def call(input)
          container = construct_container(input)
          Success(container)
        end

        private

        def construct_container(entity, namespace = nil)
          container = namespace || Dry::Container::new
          attributes = entity.attributes

          if entity.is_a?(ResourceRegistry::Entities::Option::Setting)
            container.register(entity.key, entity.default || entity.value)
            return
          end

          if entity.is_a?(ResourceRegistry::Entities::Option) && entity.key == :settings
            entity.settings.each{|setting| construct_container(setting, container) }
            return
          end

          container.namespace(attributes.delete(:key) || :enterprise) do |resolved_ns|
            attributes.each do |key, value|

              if value.is_a?(Array) && is_an_entity?(value[0])
                value.each{|val| construct_container(val, resolved_ns) }
              else
                # namespace.register(key, value)
              end
            end
          end

          container
        end

        def is_an_entity?(element)
          element.class.to_s.scan(/ResourceRegistry::Entities/).present?
        end
      end
    end
  end
end