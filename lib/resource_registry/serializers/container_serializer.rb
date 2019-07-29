module ResourceRegistry
  module Serializers
    class ContainerSerializer
      include ResourceRegistry::Services::Service

      def call(**params)
        @content = params[:content]
        @action  = params[:action]

        send(@action)
      end

      def parse
      end

      def generate
        construct_container(element: @content)
      end

      def construct_container(element: nil, namespace: nil)
        container = namespace || Dry::Container::new

        container.namespace(element.key) do |namespace|
          register_namespace_elements element.namespaces, namespace
          register_settings element.settings, namespace
        end
        
        container
      end

      private

      def register_settings(settings, namespace)
        settings.each{|setting| namespace.register(setting.key, setting.default) }
      end

      def register_namespace_elements(namespaces, namespace)
        namespaces.each {|namespace_ele| construct_container(element: namespace_ele, namespace: namespace) }
      end
    end
  end
end