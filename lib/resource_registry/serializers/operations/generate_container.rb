module ResourceRegistry
  module Serializers
    module Operations
      class GenerateContainer
        
        include Dry::Transaction::Operation

        def call(input)
          container = construct_container(element: input)
          return Success(container)
        end

        private

        def construct_container(element: nil, namespace: nil)
          container = namespace || Dry::Container::new

          container.namespace(element.key) do |namespace|
            register_namespace_elements element.namespaces, namespace
            register_settings element.settings, namespace
          end

          container
        end

        def register_settings(settings, namespace)
          return if settings.blank?
          settings.each{|setting| namespace.register(setting.key, setting.value || setting.default) }
        end

        def register_namespace_elements(namespaces, namespace)
          return if namespaces.blank?
          namespaces.each {|namespace_ele| construct_container(element: namespace_ele, namespace: namespace) }
        end
      end
    end
  end
end