# frozen_string_literal: true

# Helper methods to render setting input fields
module InputControls
  def input_filter_control(_form, feature, data)
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

  def feature_enabled_control(option, _form)
    tag.div(class: "form-group") do
      content  = option.key.to_s.titleize
      content += tag.label(class: 'switch') do
        tag.input(type: 'hidden', value: option.key, name: 'feature_key') +
          tag.input(type: "checkbox", checked: option.is_enabled) +
          tag.span(class: "slider")
      end

      content += tag.div(class: "spinner-border d-none text-success", role: "status") do
        tag.span(class: "sr-only") do
          "Loading..."
        end
      end

      content.html_safe
    end
  end

  def slider_switch_control(option, _form)
    tag.div(class: "form-group") do
      content  = option.key.to_s.titleize
      content += tag.label(class: 'switch') do
        tag.input(type: 'hidden', value: option.key, name: 'feature_key') +
          tag.input(type: "checkbox", checked: option.item) +
          tag.span(class: "slider")
      end

      content.html_safe
    end
  end

  def select_control(setting, form)
    id = setting.key.to_s
    selected_option = "Choose..."
    meta = setting.meta

    # aria_describedby = id

    value = parse_input_value(setting, form)
    option_list = tag.option(selected_option, selected: (value.blank? ? true : false))

    choices = meta.enum
    choices = meta.enum.constantize if choices.is_a?(String)

    choices.each do |choice|
      choice = choice.is_a?(Hash) ? choice.first : [choice.to_s, choice.to_s.humanize]
      option_list += tag.option(choice[1], selected: (choice[0] == value.to_s), value: choice[0])
    end

    tag.select(option_list, id: id, class: "form-control", name: input_name_for(setting, form))
  end

  def select_dropdown(input_id, list, show_default, selected = nil)
    name = (input_id.to_s.scan(/supported_languages/).present? ? input_id : "admin[#{input_id}]")

    return unless list.is_a? Array
    content_tag(:select, class: "form-control", id: input_id, name: name, required: true) do
      concat(content_tag(:option, "Select", value: "")) unless show_default
      list.each{|item| select_options_for(item, selected) }
    end
  end

  def select_options_for(item, selected)
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

  def input_import_control(setting, _form)
    id = setting[:key].to_s
    aria_describedby = id
    label = setting[:title] || id.titleize

    tag.div(class: "input-group-prepend") do
      tag.span('Upload', class: "input-group-text", id: id)
    end +
      tag.div(class: "custom-file") do
        tag.input(nil, type: "file", id: id, name: "#{id}[value]", class: "custom-file-input", aria: { describedby: aria_describedby }) +
          tag.label('Choose File', for: id, value: label, class: "custom-file-label")
      end
  end

  def input_radio_control(setting, form)
    meta = setting.meta
    input_value = parse_input_value(setting, form)
    aria_label  = "Radio button for following text input" #setting[:aria_label] || "Radio button for following text input"

    if setting.is_a?(ResourceRegistry::Setting)
      element_name = input_name_for(setting, form)
    else
      element_name = "#{form&.object_name}[is_enabled]"
      input_value  = form.object&.is_enabled
      input_value ||= setting.is_enabled
    end

    meta.enum.collect do |choice|
      choice = send(choice) if choice.is_a?(String)
      input_group do
        tag.div(tag.div(tag.input(nil, type: "radio", name: element_name, value: choice.first[0], checked: input_value.to_s == choice.first[0].to_s, required: true), class: "input-group-text"), class: "input-group-prepend") +
          tag.input(nil, type: "text", placeholder: choice.first[1], class: "form-control", aria: {label: aria_label })
      end
    end.join.html_safe
  end

  def input_checkbox_control(setting, form)
    meta = setting.meta
    input_value = parse_input_value(setting, form)
    aria_label  = 'Checkbox button for following text input'
    meta.enum.collect do |choice|
      choice = send(choice) if choice.is_a?(String)
      input_group do
        tag.div(tag.div(tag.input(nil, type: 'checkbox', name: "#{input_name_for(setting, form)}[]", value: choice.first[0], checked: input_value.include?(choice.first[0].to_s), required: false), class: 'input-group-text'),
                class: 'input-group-prepend') +
          tag.input(nil, type: 'text', placeholder: choice.first[1], class: 'form-control', aria: {label: aria_label })
      end
    end.join.html_safe
  end

  def parse_input_value(setting, form)
    value_for(setting, form) || setting.item || setting.meta.default
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

    tag.div(class: "col-2") do
      preview
    end +
      tag.div(class: 'input-group') do
        control_inputs
      end
  end

  def input_text_control(setting, form, options = {})
    id = setting[:key].to_s
    meta = setting[:meta]
    input_value = value_for(setting, form, options) || setting.item || meta&.default

    is_required = meta[:is_required] == false ? meta[:is_required] : true
    placeholder = "Enter #{meta[:label]}".gsub('*','') if meta[:description].blank?

    tag.input(nil, type: "text", value: input_value, id: id, name: input_name_for(setting, form), placeholder: placeholder, class: "form-control", required: is_required)
  end

  def input_number_control(setting, form)
    id = setting[:key].to_s
    meta = setting[:meta]
    input_value = value_for(setting, form) || meta.value || meta.default
    placeholder = "Enter #{meta[:label]}".gsub('*','')  if meta[:description].blank?

    tag.input(nil, type: "number", step: "any", value: input_value, id: id, name: input_name_for(setting, form), placeholder: placeholder, class: "form-control", required: true, oninput: "check(this)")
  end

  def input_email_control(setting, form)
    id = setting[:key].to_s
    meta = setting[:meta]
    input_value = meta.value || meta.default

    tag.input(nil, type: "email", step: "any", value: input_value, id: id, name: input_name_for(setting, form),class: "form-control", required: true, oninput: "check(this)")
  end

  def input_color_control(setting)
    id = setting[:key].to_s
    input_value = setting[:value] || setting[:default]

    tag.input(nil, type: "color", value: input_value, id: id)
  end

  def input_swatch_control(setting, form)
    id = setting[:key].to_s
    meta = setting[:meta]
    color = meta.value || meta.default

    tag.input(nil, type: "text", value: color, id: id, name: "#{form&.object_name}[value]",class: "js-color-swatch form-control") +
      tag.div(tag.button(type: "button", id: id, class: "btn", value: "", style: "background-color: #{color}"), class: "input-group-append")
  end

  def input_currency_control(setting, form)
    id = setting[:key].to_s
    meta = setting[:meta]
    input_value = meta.value || meta.default
    aria_map = { label: "Amount (to the nearest dollar)"}

    tag.div(tag.span('$', class: "input-group-text"), class: "input-group-prepend") +
      tag.input(nil, type: "text", value: input_value, id: id, name: input_name_for(setting, form), class: "form-control", aria: { map: aria_map }) +
      tag.div(tag.span('.00', class: "input-group-text"), class: "input-group-append")
  end

  def value_for(setting, form, options = {})
    if options[:record].present?
      item = setting_value(setting)
      options[:record].send(item['attribute'])
    else
      value = if form.object.class.to_s.match(/^ResourceRegistry.*/).present?
                form.object.settings.detect{|s| s.key == setting.key}&.item
              else
                form.object.send(setting.key)
              end

      value = value.to_s if value.is_a?(FalseClass)
      value
    end
  end

  def input_name_for(setting, form)
    if form.object.class.to_s.match(/^ResourceRegistry.*/).present?
      if form.index.present?
        form&.object_name.to_s + "[#{form.index}][#{setting.key}]"
      else
        form&.object_name.to_s + "[settings][#{setting.key}]"
      end
    else
      form&.object_name.to_s + "[#{setting.key}]"
    end
  end

  def setting_value(setting)
    if setting.is_a?(ResourceRegistry::Setting) && setting.item.is_a?(String)
      JSON.parse(setting.item)
    else
      setting&.item
    end
  end

  # Wrap any input group in <div> tag
  def input_group
    tag.div(yield, class: "input-group")
  end
end
