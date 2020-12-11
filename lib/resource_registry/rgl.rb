module RGL
  class DirectedAdjacencyGraph
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    def root_vertices
      vertices - edges.map{|edge| edge[1]}.uniq
    end

    def to_html(element)
    end

    def to_h(vertex)
      namespace_dict = [vertex].inject({}) do |dict, vertex|
        dict = vertex.to_h
        dict[:features] = dict[:feature_keys].collect{|key| EnrollRegistry[key].feature.to_h.except(:settings)}
        dict[:namespaces] = self.adjacent_vertices(vertex).collect{|adjacent_vertex| self.to_h(adjacent_vertex)}
        attrs_to_skip = [:feature_keys]
        attrs_to_skip << :meta if dict[:meta].empty?
        dict.except(*attrs_to_skip)
      end

      result = ResourceRegistry::Validation::NamespaceContract.new.call(namespace_dict)
      raise "Unable to construct graph due to #{result.errors.to_h}" unless result.success?
      result.to_h
    end

    def to_ul(vertex, options = {})
      dict = self.to_h(vertex) if vertex.is_a?(ResourceRegistry::Namespace)

      tag.ul(class: (options[:class_name] || 'nav flex-column flex-nowrap overflow-hidden')) do
        self.to_li(dict || vertex)
      end
    end

    def to_li(element, options = {})
      tag.li(class: (options[:class_name] || 'nav-item')) do
        content = to_nav_link(element)
        if element[:namespaces] || element[:features]
          content += tag.div(class: 'collapse', id: "nav_#{element[:key]}", 'aria-expanded': 'false') do
            (element[:features] + element[:namespaces]).reduce('') do |list, child_ele|
                list += self.to_ul(child_ele, {class_name: 'flex-column nav pl-4'})
            end.html_safe
          end
        end
        content
      end
    end

    def to_nav_link(element)
      href_options = {href: element[:item], 'data-remote': true}
      href_options = {href: "#nav_#{element[:key]}", class: "nav-link collapsed text-truncate", 'data-toggle': 'collapse', 'data-target': "#nav_#{element[:key]}"} if element[:namespaces]
      
      tag.a(href_options) do
        tag.span do
          element[:namespaces] ? element[:path].last.to_s.titleize : element[:meta][:label]
        end
      end
    end
  end
end