# frozen_string_literal: true

require 'action_view'
module ResourceRegistry
  # This would render navigation menu from registerd namespaces and features
  class Navigation
    include ActionView::Helpers::TagHelper
    include ActionView::Context

    TAG_OPTION_DEFAULTS = {
      ul: {
        options: {class: 'nav flex-column flex-nowrap overflow-auto'}
      },
      nested_ul: {
        options: {class: 'flex-column nav pl-4'}
      },
      li: {
        options: {class: 'nav-item'}
      },
      a: {
        namespace_link: {
          options: {class: 'nav-link collapsed text-truncate', 'data-toggle': 'collapse'}
        },
        feature_link: {
          options: {class: 'nav-link', 'data-remote': true}
        }
      }
    }.freeze

    AUTHORIZATION_DEFAULTS = {
      authorization_defaults: {}
    }.freeze

    NAMESPACE_OPTION_DEFAULTS = {
      include_all_disabled_features: true,
      include_no_features_defined: true,
      active_item: [:aca_shop, :benefit_market_catalogs, :catalog_2019], # TODO
      starting_namespaces: [] # start vertices for graph
    }.freeze

    OPTION_DEFAULTS = {
      tag_options: TAG_OPTION_DEFAULTS,
      authorization_options: AUTHORIZATION_DEFAULTS,
      namespace_options: NAMESPACE_OPTION_DEFAULTS
    }.freeze

    attr_reader :options, :namespaces

    def initialize(registry, options = {})
      @registry = registry
      @graph    = registry[:feature_graph]
      @options  = OPTION_DEFAULTS.deep_merge(options)

      build_namespaces
    end

    def render_html
      namespaces.collect{|namespace| to_ul(namespace)}.join.html_safe
    end

    private

    def root_vertices
      @graph.vertices_for(options[:namespace_options])
    end

    def build_namespaces
      @namespaces = root_vertices.collect{|vertex| to_namespace(vertex)}
    end

    def to_namespace(vertex)
      namespace_dict = [vertex].inject({}) do |dict, record|
        dict = record.to_h
        dict[:features] = dict[:feature_keys].collect{|key| @registry[key].feature.to_h.except(:settings)}
        dict[:namespaces] = @graph.adjacent_vertices(record).collect{|adjacent_vertex| to_namespace(adjacent_vertex)}
        attrs_to_skip = [:feature_keys]
        attrs_to_skip << :meta if dict[:meta].empty?
        dict.except(*attrs_to_skip)
      end
      result = ResourceRegistry::Validation::NamespaceContract.new.call(namespace_dict)
      raise "Unable to construct graph due to #{result.errors.to_h}" unless result.success?
      result.to_h
    end

    def to_ul(vertex, nested = false)
      dict = to_namespace(vertex) if vertex.is_a?(ResourceRegistry::Namespace)

      tag.ul(options[:tag_options][(nested ? :nested_ul : :ul)][:options]) do
        to_li(dict || vertex)
      end
    end

    def to_li(element)
      tag.li(options[:tag_options][:li][:options]) do
        if element[:namespaces] || element[:features]
          namespace_nav_link(element) + content_to_expand(element)
        else
          feature_nav_link(element)
        end
      end
    end

    def content_to_expand(element)
      tag.div(class: 'collapse', id: "nav_#{element[:key]}", 'aria-expanded': 'false') do
        nav_features = element[:features].select{|feature| feature[:meta][:content_type] == :nav}
        (nav_features + element[:namespaces]).reduce('') do |list, child_ele|
          list + to_ul(child_ele, true)
        end.html_safe
      end
    end

    def namespace_nav_link(element)
      tag.a(options[:tag_options][:a][:namespace_link][:options].merge(id: 'namespace-link', href: "#nav_#{element[:key]}", data: {target: "#nav_#{element[:key]}", feature: element[:features][0]&.[](:key)})) do
        tag.span do
          link_title(element)
          # element[:namespaces] ? element[:path].last.to_s.titleize : element[:meta][:label]
        end
      end
    end

    def feature_nav_link(element)
      feature_url = element[:item] if element[:item].to_s.match?(%r{^/.*$})
      feature_url ||= "/exchanges/configurations/#{element[:key]}/edit"
      tag.a(options[:tag_options][:a][:feature_link][:options].merge(href: feature_url)) do
        tag.span do
          link_title(element)
          # element[:namespaces] ? element[:path].last.to_s.titleize : element[:meta][:label]
        end
      end
    end

    def link_title(element)
      if element[:meta]
        element[:meta][:label]
      else
        element[:path].last.to_s.titleize
      end
    end
  end
end
