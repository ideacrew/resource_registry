# frozen_string_literal: true

module RegistryViewControls

  def render_feature(feature, form = nil)
    feature = feature.feature if feature.is_a?(ResourceRegistry::FeatureDSL)
    content = if ['legend'].include?(feature.meta.content_type.to_s)
                form.hidden_field(:is_enabled) +
                form.hidden_field(:namespace, value: feature.namespace_path.dotted_path)
              else
                build_option_field(feature, form)
              end

    content += feature.settings.collect{|setting| build_option_field(setting, form).html_safe if setting.meta}.compact.join.html_safe
    content.html_safe
  end

  def build_option_field(option, form)
    type = option.meta.content_type&.to_sym
    input_control = case type
                    when :swatch
                      input_swatch_control(option, form)
                    when :base_64
                      input_file_control(option, form)
                    when :radio_select
                      input_radio_control(option, form)
                    when :checkbox_select
                      input_checkbox_control(option, form)
                    when :select
                      select_control(option, form)
                    when :number
                      input_number_control(option, form)
                    when :email
                      input_email_control(option, form)
                    when :date
                      input_date_control(option, form)
                    when :currency
                      input_currency_control(option, form)
                    when :toggle_enabled
                      toggle_enabled_control(option, form)
                    when :slider_switch
                      slider_switch_control(option, form)
                    else
                      input_text_control(option, form)
                    end
                    # else :text_field
                    #   input_text_control(option, form)
                    # else
                    #   # :dan_check_box
                    #   # find dan_check_box_control helper
                    #   # else
                    #   # custom_helper #catch_all for custom types
                    # end

    if [:radio_select, :checkbox_select].include?(type)
      custom_form_group(option, input_control)
    else
      return input_control if type == :toggle_enabled
      form_group(option, input_control)
    end
  end

  def toggle_enabled_control(option, form)
    tag.div(class: "form-group") do
      tag.label(for: option.key.to_s, value: option.key.to_s.titleize, class: 'pr-2') do
        option.key.to_s.titleize
      end +
        tag.input(nil, id: 'featureToggle', type: "checkbox", checked: option.is_enabled, data: {toggle: 'toggle', style: 'ios'})
    end
  end

  def slider_switch_control(option, form)

  end

  def select_control(setting, form)
    id = setting[:key].to_s
    selected_option = "Choose..."
    meta = setting[:meta]

    # aria_describedby = id

    value = value_for(setting, form) || setting.item || meta&.default
    option_list = tag.option(selected_option, selected: (value.blank? ? true : false))
    meta.enum.each do |choice|
      option_list += tag.option(choice.first[1], selected: (choice.first[0].to_s == value.to_s), value: choice.first[0])
    end

    tag.select(option_list, id: id, class: "form-control", name: input_name_for(setting, form))
  end

  def select_dropdown(input_id, list, show_default = false, selected = nil)
    name = (input_id.to_s.scan(/supported_languages/).present? ? input_id : 'admin[' + input_id.to_s + ']')

    return unless list.is_a? Array
    content_tag(:select, class: "form-control", id: input_id, name: name, required: true) do
      concat(content_tag(:option, "Select", value: "")) unless show_default
      list.each do |item|
        if item.is_a? Array
          is_selected = false
          is_selected = true if selected.present? && selected == item[1]
          concat(content_tag(:option, item[0], value: item[1], selected: is_selected))
        elsif item.is_a? Hash
          concat(content_tag(:option, item.first[1], value: item.first[0]))
        elsif input_id == 'state'
          concat(content_tag(:option, item.to_s.titleize, value: item))
        elsif show_default
          concat(content_tag(:option, item, value: item))
        else
          concat(content_tag(:option, item.to_s.humanize, value: item))
        end
      end
    end
  end

  def input_import_control(setting, _form)
    id = setting[:key].to_s
    aria_describedby = id
    label = setting[:title] || id.titleize

    tag.div(class: "input-group-prepend") do
      tag.span('Upload', class: "input-group-text", id: id)
    end +
      tag.div(class: "custom-file") do
        tag.input(nil, type: "file", id: id, name: id + "[value]", class: "custom-file-input", aria: { describedby: aria_describedby }) +
          tag.label('Choose File', for: id, value: label, class: "custom-file-label")
      end
  end

  def input_radio_control(setting, form)
    meta = setting.meta
    input_value = value_for(setting, form) || setting.item || meta&.default
    aria_label  = "Radio button for following text input" #setting[:aria_label] || "Radio button for following text input"

    if setting.is_a?(ResourceRegistry::Setting)
      element_name = input_name_for(setting, form)
    else
      element_name = form&.object_name.to_s + "[is_enabled]"
      input_value  = form.object&.is_enabled
      input_value  = setting.is_enabled if input_value.blank?
    end

    meta.enum.collect do |choice|
      choice = send(choice) if choice.is_a?(String)
      input_group do
        tag.div(tag.div(tag.input(nil, type: "radio", name: element_name, value: choice.first[0], checked: input_value.to_s == choice.first[0].to_s, required: true), class: "input-group-text"), class: "input-group-prepend") +
          tag.input(nil, type: "text", placeholder: choice.first[1], class: "form-control", aria: {label: aria_label })
      end
    end.join('').html_safe
  end

  def input_checkbox_control(setting, form)
    meta = setting.meta
    input_value = value_for(setting, form) || setting.item || meta&.default
    aria_label  = 'Checkbox button for following text input'
    meta.enum.collect do |choice|
      choice = send(choice) if choice.is_a?(String)
      input_group do
        tag.div(tag.div(tag.input(nil, type: 'checkbox', name: "#{input_name_for(setting, form)}[]", value: choice.first[0], checked: input_value.include?(choice.first[0].to_s), required: false), class: 'input-group-text'), class: 'input-group-prepend') +
          tag.input(nil, type: 'text', placeholder: choice.first[1], class: 'form-control', aria: {label: aria_label })
      end
    end.join('').html_safe
  end

  def input_file_control(setting, form)
    meta = setting.meta
    id = setting.key.to_s
    aria_describedby = id
    label = meta.label
    input_value = setting.item || meta.default

    preview = if input_value.present?
                tag.img(class: 'w-100', src: "data:#{meta.type};base64,#{input_value}")
              else
                tag.span('No logo')
              end

    control_inputs =
      tag.div(class: "input-group-prepend") do
        tag.span('Upload', class: "input-group-text", id: id)
      end +
      tag.div(class: "custom-file") do
        tag.input(nil, type: "file", id: id, name: form&.object_name.to_s + "[#{setting.key}]", class: "custom-file-input", aria: { describedby: aria_describedby }) +
          tag.label('Choose File', for: id, value: label, class: "custom-file-label")
      end

    control =
      tag.div(class: "col-2") do
        preview
      end +
      tag.div(class: 'input-group') do
        control_inputs
      end

    control
  end

  # Wrap any input group in <div> tag
  def input_group
    tag.div(yield, class: "input-group")
  end

  def value_for(setting, form)
    value = if form.object.class.to_s.match(/^ResourceRegistry.*/).present?
              form.object.settings.where(key: setting.key).first&.item
            else
              form.object.send(setting.key)
            end

    value = value.to_s if value.is_a?(FalseClass)
    value
  end

  def input_name_for(setting, form)
    if form.object.class.to_s.match(/^ResourceRegistry.*/).present?
      form&.object_name.to_s + "[settings][#{setting.key}]"
    else
      form&.object_name.to_s + "[#{setting.key}]"
    end
  end

  def input_text_control(setting, form)
    id = setting[:key].to_s

    meta = setting[:meta]
    input_value = value_for(setting, form) || setting.item || meta&.default

    # aria_describedby = id

    is_required = meta[:is_required] == false ? meta[:is_required] : true
    placeholder = "Enter #{meta[:label]}".gsub('*','') if meta[:description].blank?
    # if meta[:attribute]
    #   tag.input(nil, type: "text", value: input_value, id: id, name: form&.object_name.to_s + "[#{id}]",class: "form-control", required: true)
    # else

    tag.input(nil, type: "text", value: input_value, id: id, name: input_name_for(setting, form), placeholder: placeholder, class: "form-control", required: is_required)
    # end
  end

  def input_date_control(setting, form)
    id = setting[:key].to_s

    date_value = value_for(setting, form)
    date_value = date_value.to_date if date_value.is_a?(Time)
    date_value = date_value.to_s(:db) if date_value.is_a?(Date)

    meta = setting[:meta]
    input_value = date_value || setting.item || meta&.default
    # aria_describedby = id

    is_required = meta&.is_required == false ? meta.is_required : true

    tag.input(nil, type: "date", value: input_value, id: id, name: input_name_for(setting, form), placeholder: "mm/dd/yyyy", class: "form-control", required: is_required)
  end

  def input_number_control(setting, form)
    id = setting[:key].to_s
    meta = setting[:meta]
    input_value = value_for(setting, form) || meta.value || meta.default
    # input_value = setting[:value] || setting[:default]
    # aria_describedby = id
    placeholder = "Enter #{meta[:label]}".gsub('*','')  if meta[:description].blank?

    # if setting[:attribute]
    tag.input(nil, type: "number", step: "any", value: input_value, id: id, name: input_name_for(setting, form), placeholder: placeholder, class: "form-control", required: true, oninput: "check(this)")
    # else
    #   tag.input(nil, type: "number", step:"any", value: input_value, id: id, name: form&.object_name.to_s + "[value]",class: "form-control", required: true, oninput: "check(this)")
    # end
  end

  def input_email_control(setting, form)
    id = setting[:key].to_s
    meta = setting[:meta]
    input_value = meta.value || meta.default
    # input_value = setting[:value] || setting[:default]
    # aria_describedby = id

    # if setting[:attribute]
    tag.input(nil, type: "email", step: "any", value: input_value, id: id, name: input_name_for(setting, form),class: "form-control", required: true, oninput: "check(this)")
    # else
    #   tag.input(nil, type: "email", step:"any", value: input_value, id: id, name: form&.object_name.to_s + "[value]",class: "form-control", required: true, oninput: "check(this)")
    # end
  end

  def input_color_control(setting)
    id = setting[:key].to_s
    input_value = setting[:value] || setting[:default]

    tag.input(nil, type: "color", value: input_value, id: id)
  end

  def input_swatch_control(setting, form)
    # id = setting[:key].to_s
    # color = setting[:value] || setting[:default]
    id = setting[:key].to_s
    meta = setting[:meta]
    color = meta.value || meta.default

    tag.input(nil, type: "text", value: color, id: id, name: form&.object_name.to_s + "[value]",class: "js-color-swatch form-control") +
      tag.div(tag.button(type: "button", id: id, class: "btn", value: "", style: "background-color: #{color}"), class: "input-group-append")
  end

  def input_currency_control(setting, form)
    id = setting[:key].to_s
    meta = setting[:meta]
    input_value = meta.value || meta.default

    # id          = setting[:key].to_s
    # input_value = setting[:value] || setting[:default]
    aria_map = { label: "Amount (to the nearest dollar)"}

    tag.div(tag.span('$', class: "input-group-text"), class: "input-group-prepend") +
      tag.input(nil, type: "text", value: input_value, id: id, name: input_name_for(setting, form), class: "form-control", aria: { map: aria_map }) +
      tag.div(tag.span('.00', class: "input-group-text"), class: "input-group-append")
  end

  def build_attribute_field(form, attribute)
    setting = {
      key: attribute,
      default: form.object.send(attribute),
      type: :string,
      attribute: true
    }

    input_control = input_text_control(setting, form)
    form_group(setting, input_control)
  end


  ## FORM GROUPS

  # Build a general-purpose form group wrapper around the supplied input control
  def form_group(setting, control)
    id          = setting[:key].to_s
    # label       = setting[:title] || id.titleize
    label       = setting.meta.label || id.titleize
    help_id     = id + 'HelpBlock'
    # help_text   = setting[:description]
    # aria_label  = setting[:aria_label] || "Radio button for following text input"
    help_text   = setting.meta.description
    aria_label  = "Radio button for following text input" #setting[:aria_label] || "Radio button for following text input"

    tag.div(class: "form-group") do
      tag.label(for: id, value: label, aria: { label: aria_label }) do
        label
      end +
        input_group { control } + tag.small(help_text, id: help_id, class: ['form-text', 'text-muted'])
    end
  end

  def custom_form_group(setting, control)
    id          = setting[:key].to_s
    # label       = setting[:title] || id.titleize
    label       = setting.meta.label || id.titleize
    help_id     = id + 'HelpBlock'
    help_text   = setting.meta.description
    aria_label  = "#{setting.meta.content_type.to_s.humanize} button for following text input" #setting[:aria_label] || "Radio button for following text input"

    tag.div(class: "form-group") do
      tag.label(for: id, value: label, aria: { label: aria_label }) do
        label
      end +
        control + tag.small(help_text, id: help_id, class: ['form-text', 'text-muted'])
    end
  end

  def list_group_menu(nested_namespaces = nil, features = nil, options = {})
    content = ''
    tag.div({class: "list-group", id: "list-tab", role: "tablist"}.merge(options)) do

      if features
        features.each do |feature|
          feature_rec = ResourceRegistry::ActiveRecord::Feature.where(key: feature).first

          content += tag.a(href: "##{feature}", class: "list-group-item list-group-item-action border-0", 'data-toggle': 'list', role: 'tab', id: "list-#{feature}-list", 'aria-controls': feature.to_s) do
            feature_rec&.setting(:label)&.item || feature.to_s.titleize
          end.html_safe
        end
      end

      if nested_namespaces
        nested_namespaces.each do |namespace, children|

          content += tag.a(href: "##{namespace}-group", class: "list-group-item list-group-item-action border-0", 'data-toggle': 'collapse', role: 'tab', id: "list-#{namespace}-list", 'aria-controls': namespace.to_s) do
            "+ #{namespace.to_s.titleize}"
          end

          content += tag.span('data-toggle': 'list') do
            list_group_menu(children[:namespaces], children[:features], {class: "list-group collapse ml-4", id: "#{namespace}-group"})
          end
        end
      end

      content.html_safe
    end
  end

  def list_tab_panels(features, feature_registry, _options = {})
    tag.div(class: 'card') do
      # content = tag.div(class: 'card-header') do
      #   tag.h4(feature.setting(:label)&.item || feature.key.to_s.titleize)
      # end

      content = tag.div(class: 'card-body') do
        feature_content = ''
        features.each do |feature_key|
          feature = defined?(Rails) ? find_feature(feature_key) : feature_registry[feature_key].feature
          next if feature.blank?

          feature_content += tag.div(id: feature_key.to_s, role: 'tabpanel', 'aria-labelledby': "list-#{feature_key}-list") do
            form_for(feature, as: 'feature', url: exchanges_configuration_path(feature), method: :patch, remote: true, authenticity_token: true) do |form|
              form.hidden_field(:key) +
                render_feature(feature, form) +
                tag.div(class: 'row mt-3') do
                  # tag.div(class: 'col-4') do
                  #   form.submit(class: 'btn btn-primary')
                  # end +
                    tag.div(class: 'col-6') do
                      tag.div(class: 'flash-message', id: feature_key.to_s + '-alert')
                    end
                end
            end
          end
        end
        feature_content.html_safe
      end.html_safe
    end
  end

  def find_feature(feature_key)
    if defined? ResourceRegistry::Mongoid
      ResourceRegistry::Mongoid::Feature.where(key: feature_key).first
    else
      ResourceRegistry::ActiveRecord::Feature.where(key: feature_key).first
    end
  end
end
