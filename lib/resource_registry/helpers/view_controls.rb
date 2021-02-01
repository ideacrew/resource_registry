# frozen_string_literal: true

require_relative 'input_controls'

module RegistryViewControls
  include ::InputControls

  def render_feature(feature, form, registry = nil)
    return render_model_feature(feature, form, registry) if feature.meta.content_type == :model_attributes

    feature = feature.feature if feature.is_a?(ResourceRegistry::FeatureDSL)
    content = form.hidden_field(:is_enabled)

    if ['legend'].include?(feature.meta.content_type.to_s)
      content += form.hidden_field(:namespace, value: feature.namespace_path.path.map(&:to_s).join('.'))
    elsif feature.meta.content_type == :feature_enabled
      content += build_option_field(feature, form)
    end

    content += feature.settings.collect{|setting| build_option_field(setting, form).html_safe if setting.meta}.compact.join.html_safe
    content.html_safe
  end

  def render_model_feature(feature, form, registry)
    query_setting = feature.settings.detect{|setting| setting.key == :model_query_params}
    query_params = setting_value(query_setting)

    result = @filter_result
    result = registry[feature.key]{ query_params || {}}.success unless result
    filter_setting = feature.settings.detect{|s| s.key == :filter_params}

    content = ''
    content = render_filter(form, feature, result).html_safe if filter_setting
    content += form.hidden_field(:is_enabled)
    content += form.hidden_field(:namespace, value: feature.namespace_path.path.map(&:to_s).join('.'))

    feature.settings.each do |setting|
      next if setting.meta.blank? || setting.key == :filter_params
      content += build_option_field(setting, form, {record: result[:record]})
    end

    content.html_safe
  end

  def render_filter(form, feature, data)
    filter_setting = feature.settings.detect{|s| s.key == :filter_params}
    filter_params = setting_value(filter_setting)

    option_list = tag.option(filter_setting.meta.label)
    data[:calender_years].collect do |choice|
      option_list += tag.option(choice, selected: (choice == data[:catalog_year]), value: choice)
    end

    tag.div(class: 'row mb-4') do
      tag.div(class: 'col-4') do
        content = filter_params['criteria'].reduce([]) do |strs, (attr, value)|
          strs << tag.input(type: 'hidden', id: "filter_#{attr}", name: "filter[#{attr}]", value: value)
        end.join
        content += tag.input(type: 'hidden', id: :target_feature, name: :target_feature, value: feature.key.to_s)
        content += tag.select(option_list, id: filter_params['name'], class: "form-control feature-filter", name: "filter[#{filter_params['name']}]")
        content.html_safe
      end
    end
  end

  # def list_group_menu(nested_namespaces = nil, features = nil, options = {})
  #   content = ''
  #   tag.div({class: "list-group", id: "list-tab", role: "tablist"}.merge(options)) do

  #     if features
  #       features.each do |feature|
  #         feature_rec = ResourceRegistry::ActiveRecord::Feature.where(key: feature).first

  #         content += tag.a(href: "##{feature}", class: "list-group-item list-group-item-action border-0", 'data-toggle': 'list', role: 'tab', id: "list-#{feature}-list", 'aria-controls': feature.to_s) do
  #           feature_rec&.setting(:label)&.item || feature.to_s.titleize
  #         end.html_safe
  #       end
  #     end

  #     if nested_namespaces
  #       nested_namespaces.each do |namespace, children|

  #         content += tag.a(href: "##{namespace}-group", class: "list-group-item list-group-item-action border-0", 'data-toggle': 'collapse', role: 'tab', id: "list-#{namespace}-list", 'aria-controls': namespace.to_s) do
  #           "+ #{namespace.to_s.titleize}"
  #         end

  #         content += tag.span('data-toggle': 'list') do
  #           list_group_menu(children[:namespaces], children[:features], {class: "list-group collapse ml-4", id: "#{namespace}-group"})
  #         end
  #       end
  #     end

  #     content.html_safe
  #   end
  # end

  # def list_tab_panels(features, feature_registry, _options = {})
  #   tag.div(class: 'card') do
  #     # content = tag.div(class: 'card-header') do
  #     #   tag.h4(feature.setting(:label)&.item || feature.key.to_s.titleize)
  #     # end

  #     content = tag.div(class: 'card-body') do
  #       feature_content = ''
  #       features.each do |feature_key|
  #         feature = defined?(Rails) ? find_feature(feature_key) : feature_registry[feature_key].feature
  #         next if feature.blank?

  #         feature_content += tag.div(id: feature_key.to_s, role: 'tabpanel', 'aria-labelledby': "list-#{feature_key}-list") do
  #           form_for(feature, as: 'feature', url: exchanges_configuration_path(feature), method: :patch, remote: true, authenticity_token: true) do |form|
  #             form.hidden_field(:key) +
  #               render_feature(feature, form) +
  #               tag.div(class: 'row mt-3') do
  #                 tag.div(class: 'col-4') do
  #                   form.submit(class: 'btn btn-primary')
  #                 end +
  #                   tag.div(class: 'col-6') do
  #                     tag.div(class: 'flash-message', id: feature_key.to_s + '-alert')
  #                   end
  #               end
  #           end
  #         end
  #       end
  #       feature_content.html_safe
  #     end.html_safe
  #   end
  # end

  def namespace_panel(namespace, feature_registry, _options = {})
    tag.div(class: 'card') do
      tag.div(class: 'card-body') do        
        if namespace.features.any?{|f| f.meta.content_type == :model_attributes}
          namespace.features.collect{|feature| construct_feature_form(feature, feature_registry)}.join(tag.hr(class: 'mt-2 mb-3')).html_safe
        else
          construct_namespace_form(namespace, feature_registry)
        end
      end.html_safe
    end
  end

  def construct_namespace_form(namespace, registry)
    form_for(namespace, as: 'namespace', url: update_namespace_exchanges_configurations_path, method: :post, remote: true, authenticity_token: true) do |form|
      namespace_content = form.hidden_field(:path, value: namespace.path.map(&:to_s).join('.'))

      namespace.features.each_with_index do |feature, index|
        namespace_content += form.fields_for :features, feature, {index: index} do |feature_form|
          tag.div(id: feature.key.to_s, role: 'tabpanel', 'aria-labelledby': "list-#{feature.key}-list", class: 'mt-2') do
            feature_form.hidden_field(:key) +
            render_feature(feature, feature_form, feature_registry)
          end
        end
      end

      namespace_content += tag.div(class: 'row mt-3') do
          tag.div(class: 'col-4') do
            form.submit('Save', class: 'btn btn-primary')
          end +
          tag.div(class: 'col-6') do
            tag.div(class: 'flash-message', id: namespace.path.map(&:to_s).join('-') + '-alert')
          end
        end

      namespace_content.html_safe
    end
  end
  
  def feature_panel(feature_key, registry, options = {})
    @filter_result = options[:filter_result]

    tag.div(class: 'card') do
      tag.div(class: 'card-body') do
        feature  = get_feature(feature_key, registry)
        if feature.present?
          features = [feature]
          if feature.item == 'features_display'
            feature_group_display(feature)
          else
            if feature.item == 'feature_collection'
              features_setting = feature.settings.detect{|setting| setting.meta&.content_type.to_s == 'feature_list_panel'}
              feature_keys = features_setting.item
              features = feature_keys.collect{|key| get_feature(key, registry)}.compact
            end
            features.collect{|feature| construct_feature_form(feature, registry, options)}.join(tag.hr(class: 'mt-2 mb-3')).html_safe
          end
        end
      end
    end
  end

  def construct_feature_form(feature, registry, options = {})
    if options[:action_params]
      clone_action = options[:action_params][:action].to_s == 'clone'
    end

    submit_path = if clone_action
      clone_feature_exchanges_configuration_path(feature.key)
    else
      update_feature_exchanges_configuration_path(feature.key)
    end

    tag.div(id: feature.key.to_s, 'aria-labelledby': "list-#{feature.key}-list", class: 'card border-0') do
      tag.div(class: 'card-body') do
        tag.div(class: 'card-title h6 font-weight-bold mb-4') do
          feature.meta.label
        end +
        form_for(feature, as: 'feature', url: submit_path, method: :post, remote: true, authenticity_token: true) do |form|
          form.hidden_field(:key) +
          (clone_action ? hidden_field_tag('feature[target_feature]', options[:action_params][:key]) : '') +
            render_feature(feature, form, registry) +
            tag.div(class: 'row mt-3') do
              tag.div(class: 'col-4') do
                form.submit('Save', class: 'btn btn-primary')
              end +
                tag.div(class: 'col-6') do
                  tag.div(class: 'flash-message', id: feature.key.to_s + '-alert')
                end
            end
        end
      end
    end
  end

  def feature_group_display(feature)
    tag.div(id: feature.key.to_s, role: 'tabpanel', 'aria-labelledby': "list-#{feature.key}-list") do
      feature.settings.collect do |setting|
        feature_group_control(feature, setting).html_safe if setting.meta && setting.meta.content_type.to_s == 'feature_group'
      end.compact.join.html_safe
    end.html_safe
  end

  def feature_group_control(source_feature, option)
    features = option.item.collect{|key| find_feature(key)}
    features.collect do |feature|
      tag.div(class: 'mt-3') do
        tag.div(class: 'row') do
          tag.div(class: 'col-md-6') do
            tag.h4 do
              feature.meta.label
            end
          end +
          tag.div(class: 'col-md-6') do
            action_setting = feature.settings.detect{|setting| setting.meta.content_type.to_s == 'feature_action'}
            if action_setting
              form_with(model: feature, url: action_setting.item, method: :get, remote: true, local: false) do |f|
                hidden_field_tag('feature[action]', 'clone') +
                hidden_field_tag('feature[key]', feature.key) +
                f.submit('Clone', class: 'btn btn-link')
              end.html_safe
              # tag.a(href: action_setting.item + "?", data: {remote: true}) do
              #   tag.span { "Clone" }
              # end
            end
          end
        end +
        feature.settings.collect do |setting|
          next if setting.meta.content_type.to_s == 'feature_action'
          section_name = setting.meta&.label || setting.key.to_s.titleize
          tag.div(class: 'mt-3') do
            tag.div(class: 'row') do
              tag.div(class: 'col-md-4') do
                tag.strong do
                  section_name
                end
              end +
              tag.div(class: 'col-md-4') do
                tag.a(href: "/exchanges/configurations/#{feature.key}/edit", data: {remote: true}) do
                  tag.span do
                    "View #{section_name}"
                  end
                end
              end +
              tag.div(class: 'col-md-6') do
                tag.ul(class: 'list-group list-group-flush ml-2') do
                  setting.item.collect{|value| tag.li(class: 'list-group-item'){ value.to_s.titleize }}.join.html_safe
                end
              end
            end
          end
        end.compact.join.html_safe
      end
    end.join.html_safe
  end

  def get_feature(feature_key, registry)
    defined?(Rails) ? find_feature(feature_key) : registry[feature_key].feature
  end

  def find_feature(feature_key)
    feature_class = ResourceRegistry::Stores.feature_model
    return unless feature_class
    feature_class.where(key: feature_key).first
  end
end