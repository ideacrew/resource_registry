module RGL
  class DirectedAdjacencyGraph
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    TAG_OPTION_DEFAULTS = {
														ul: {
														  options: {class: 'nav flex-column flex-nowrap overflow-hidden'}
														},
														nested_ul: {
															options: {class: 'flex-column nav pl-4'}
														},
														li: {
															options: {class: 'nav-item'}
														},
														a: {
														  namespace_link: {
														    options: {class: 'nav-link collapsed text-truncate', 'data-toggle': 'collapse'},
														  },
														  feature_link: {
														    options: {'data-remote': true}
														  }
														}
													}

    def root_vertices
      vertices - edges.map{|edge| edge[1]}.uniq
    end

    def tag_options=(options = {})
      @tag_options = TAG_OPTION_DEFAULTS.merge(options)
    end

    def tag_options
      @tag_options || TAG_OPTION_DEFAULTS
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

    def to_ul(vertex, nested = false)
      dict = self.to_h(vertex) if vertex.is_a?(ResourceRegistry::Namespace)

      tag.ul(tag_options[(nested ? :nested_ul : :ul)][:options]) do
        to_li(dict || vertex)
      end
    end

    private

    def to_li(element)
      tag.li(tag_options[:li][:options]) do
        if element[:namespaces] || element[:features]
          namespace_nav_link(element) + content_to_expand(element)
        else
          feature_nav_link(element)
        end
      end
    end

    def content_to_expand(element)
      tag.div(class: 'collapse', id: "nav_#{element[:key]}", 'aria-expanded': 'false') do
        (element[:features] + element[:namespaces]).reduce('') do |list, child_ele|
          list += self.to_ul(child_ele, true)
        end.html_safe
      end
    end

    def namespace_nav_link(element)
      tag.a(tag_options[:a][:namespace_link][:options].merge(href: "#nav_#{element[:key]}", 'data-target': "#nav_#{element[:key]}")) do
        tag.span do
          element[:namespaces] ? element[:path].last.to_s.titleize : element[:meta][:label]
        end
      end
    end

    def feature_nav_link(element)
      tag.a(tag_options[:a][:feature_link][:options].merge(href: element[:item])) do
        tag.span do
          element[:namespaces] ? element[:path].last.to_s.titleize : element[:meta][:label]
        end
      end
    end
  end
end
