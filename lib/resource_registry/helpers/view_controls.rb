# frozen_string_literal: true

require_relative 'input_controls'
# Helper methods to render interface from features/settings
module RegistryViewControls
  include ::InputControls

  def render_settings(feature, form, registry, options)
    return render_model_settings(feature, form, registry, options) if feature.meta.content_type == :model_attributes

    feature = feature.feature if feature.is_a?(ResourceRegistry::FeatureDSL)
    content = form.hidden_field(:is_enabled)

    if ['legend'].include?(feature.meta.content_type.to_s)
      content += form.hidden_field(:namespace, value: feature.namespace_path.path.map(&:to_s).join('.'))
    elsif feature.meta.content_type == :feature_enabled
      content += build_option_field(feature, form, options)
    end

    content += feature.settings.collect{|setting| build_option_field(setting, form, options).html_safe if setting.meta}.compact.join.html_safe
    content.html_safe
  end

  def render_model_settings(feature, form, registry, options)
    query_setting = feature.settings.detect{|setting| setting.key == :model_query_params}
    query_params = setting_value(query_setting)
    result = @filter_result
    result ||= registry[feature.key]{ query_params || {}}.success
    filter_setting = feature.settings.detect{|s| s.key == :filter_params}

    content = ''
    content = input_filter_control(form, feature, result).html_safe if filter_setting
    content += form.hidden_field(:is_enabled)
    content += form.hidden_field(:namespace, value: feature.namespace_path.path.map(&:to_s).join('.'))

    if result[:record]
      feature.settings.each do |setting|
        next if setting.meta.blank? || setting.key == :filter_params
        content += build_option_field(setting, form, options.merge(record: result[:record]))
      end
    end

    content.html_safe
  end

  def namespace_panel(namespace, feature_registry, options = {})
    tag.div(class: 'card') do
      tag.div(class: 'card-body') do
        if namespace.features.any?{|f| f.meta.content_type == :model_attributes}
          namespace.features.collect{|feature| construct_feature_form(feature, feature_registry, options)}.join(tag.hr(class: 'mt-2 mb-3')).html_safe
        else
          construct_namespace_form(namespace, feature_registry, options)
        end
      end.html_safe
    end
  end

  def construct_namespace_form(namespace, _registry, options)
    form_for(namespace, as: 'namespace', url: update_namespace_exchanges_configurations_path, method: :post, remote: true, authenticity_token: true) do |form|
      namespace_content = form.hidden_field(:path, value: namespace.path.map(&:to_s).join('.'))

      namespace.features.each_with_index do |feature, index|
        namespace_content += form.fields_for :features, feature, {index: index} do |feature_form|
          tag.div(id: feature.key.to_s, role: 'tabpanel', 'aria-labelledby': "list-#{feature.key}-list", class: 'mt-2') do
            feature_form.hidden_field(:key) +
              render_settings(feature, feature_form, feature_registry, options)
          end
        end
      end

      namespace_content += tag.div(class: 'row mt-3') do
        tag.div(class: 'col-4') do
          form.submit('Save', class: 'btn btn-primary')
        end +
          tag.div(class: 'col-6') do
            tag.div(class: 'flash-message', id: "#{namespace.path.map(&:to_s).join('-')}-alert")
          end
      end

      namespace_content.html_safe
    end
  end

  def feature_panel(feature_key, registry, options = {})
    @filter_result = options[:filter_result]
    @horizontal = true if options[:horizontal]

    tag.div(class: 'card') do
      tag.div(class: 'card-body') do
        feature = get_feature(feature_key, registry)
        if feature.present?
          features = [feature]
          if feature.item == 'features_display'
            feature_group_display(feature, registry)
          else
            if feature.item == 'feature_collection'
              list_panel_setting = feature.settings.detect{|setting| setting.meta&.content_type.to_s == 'feature_list_panel'}
              features = setting_value(list_panel_setting)
            end
            features.collect{|f| construct_feature_form(f, registry, options)}.join(tag.hr(class: 'mt-2 mb-3')).html_safe
          end
        end
      end
    end
  end

  def construct_feature_form(feature, registry, options)
    renew_action = options[:action_params][:action].to_s == 'renew' if options[:action_params]

    submit_path = if renew_action
                    renew_feature_exchanges_configuration_path(feature.key)
                  else
                    update_feature_exchanges_configuration_path(feature.key)
                  end

    tag.div(id: feature.key.to_s, 'aria-labelledby': "list-#{feature.key}-list", class: 'card border-0') do
      tag.div(class: 'card-body') do
        tag.div(class: 'card-title h6 font-weight-bold mb-4') do
          feature.meta&.label || feature.key.to_s.titleize
        end +
          form_for(feature, as: 'feature', url: submit_path, method: :post, remote: true, authenticity_token: true) do |form|
            form.hidden_field(:key) +
              (renew_action ? hidden_field_tag('feature[target_feature]', options[:action_params][:key]) : '') +
              render_settings(feature, form, registry, options) +
              tag.div(class: 'row mt-3') do
                tag.div(class: 'col-4') do
                  form.submit('Save', class: 'btn btn-primary')
                end +
                  tag.div(class: 'col-6') do
                    tag.div(class: 'flash-message', id: "#{feature.key}-alert")
                  end
              end
          end
      end
    end
  end

  def feature_group_display(feature, registry)
    tag.div(id: feature.key.to_s, role: 'tabpanel', 'aria-labelledby': "list-#{feature.key}-list") do
      feature.settings.collect do |setting|
        if setting.meta&.content_type.to_s == 'feature_group'
          features = setting_value(setting)
          feature_group_control(features, registry).html_safe
        end
      end.compact.join.html_safe
    end
  end

  def feature_group_control(features, _registry)
    features = features.select{|feature| feature.meta.present? && feature.meta.content_type.to_s != 'feature_action' }

    features.collect do |feature|
      settings_with_meta = feature.settings.select{|s| s.meta.present?}

      tag.div(class: 'mt-3') do
        tag.div(class: 'row') do
          tag.div(class: 'col-md-6') do
            tag.h4 do
              feature.meta&.label || feature.key.to_s.titleize
            end
          end +
            tag.div(class: 'col-md-6') do
              action_setting = settings_with_meta.detect{|setting| setting.meta.content_type.to_s == 'feature_action'}
              if action_setting
                form_with(model: feature, url: action_setting.item, method: :get, remote: true, local: false) do |f|
                  hidden_field_tag('feature[action]', 'renew') +
                    hidden_field_tag('feature[key]', feature.key) +
                    f.submit(action_setting.key.to_s.titleize, class: 'btn btn-link')
                end.html_safe
              end
            end
        end +
          settings_with_meta.collect do |setting|
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
                      feature_list = setting_value(setting)
                      feature_list.collect{|f| tag.li(class: 'list-group-item'){ f.key.to_s.titleize }}.join.html_safe
                    end
                  end
              end
            end
          end.compact.join.html_safe
      end
    end.join
  end

  def get_feature(feature_key, registry)
    defined?(Rails) ? find_feature(feature_key) : registry[feature_key].feature
  end

  def find_feature(feature_key)
    feature_class = ResourceRegistry::Stores.feature_model
    return unless feature_class
    feature_class.where(key: feature_key).first
  end

  def setting_value(setting)
    value = if setting.is_a?(ResourceRegistry::Setting)
              JSON.parse(setting.item)
            else
              setting.item
            end

    if value.is_a?(Hash) && value['operation']
      elements = value['operation'].split(/\./)
      elements[0].constantize.send(elements[1]).call(value['params'].symbolize_keys).success
    else
      value
    end
  end
end