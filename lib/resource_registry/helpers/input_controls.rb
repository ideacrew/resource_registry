module InputControls

  def build_option_field(option, form, attrs = {})
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
                    when :date_range
                      input_date_range_control(option, form)
                    when :currency
                      input_currency_control(option, form)
                    when :feature_enabled
                      feature_enabled_control(option, form)
                    when :slider_switch
                      slider_switch_control(option, form)
                    else
                      input_text_control(option, form, attrs)
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
      return input_control if [:feature_enabled, :slider_switch].include?(type)
      form_group(option, input_control)
    end
  end

  def feature_enabled_control(option, form)
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

  def slider_switch_control(option, form)
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

  def input_text_control(setting, form, options = {})
    id = setting[:key].to_s

    meta = setting[:meta]
    input_value = value_for(setting, form, options) || setting.item || meta&.default

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

    is_required = meta[:is_required] == false ? meta[:is_required] : true

    tag.input(nil, type: "date", value: input_value, id: id, name: input_name_for(setting, form), placeholder: "mm/dd/yyyy", class: "form-control", required: is_required)
  end


  def input_date_range_control(setting, form)
    meta = setting[:meta]

    date_bounds = setting.item.split('..').collect do |date_str|
      if date_str.match?(/\d{4}-\d{2}-\d{2}/)
        date_str
      else
        date = Date.strptime(date_str, "%m/%d/%Y")
        date.to_s(:db)
      end
    end

    is_required = meta[:is_required] == false ? meta[:is_required] : true

    from_input_name = form&.object_name.to_s + "[settings][#{setting.key}][begin]"
    to_input_name = form&.object_name.to_s + "[settings][#{setting.key}][end]"

    tag.input(nil, type: "date", value: date_bounds[0], id: from_input_name, name: from_input_name, placeholder: "mm/dd/yyyy", class: "form-control", required: is_required) +
    tag.div(class: 'input-group-addon') { 'to' } +
    tag.input(nil, type: "date", value: date_bounds[1], id: to_input_name, name: to_input_name, placeholder: "mm/dd/yyyy", class: "form-control", required: is_required)
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

  # Wrap any input group in <div> tag
  def input_group
    tag.div(yield, class: "input-group")
  end

  # Build a general-purpose form group wrapper around the supplied input control
  def form_group(setting, control, options = {horizontal: true, tooltip: true})
    id          = setting[:key].to_s
    # label       = setting[:title] || id.titleize
    label       = setting.meta.label || id.titleize
    help_id     = id + 'HelpBlock'
    # help_text   = setting[:description]
    # aria_label  = setting[:aria_label] || "Radio button for following text input"
    help_text   = setting.meta.description
    aria_label  = "Radio button for following text input" #setting[:aria_label] || "Radio button for following text input"

    tag.div(class: "form-group") do
      if options[:horizontal]
        tag.div(class: 'row') do
          tag.div(class: 'col col-sm-12 col-md-4') do
            tag.label(for: id, value: label, aria: { label: aria_label }) do
              label
            end
          end +
          tag.div(class: 'col col-sm-12 col-md-1') do
            tag.i(class: 'fas fa-info-circle', rel: 'tooltip', title: setting.meta.description) if options[:tooltip]
          end +
          tag.div(class: 'col col-sm-12 col-md-7') do
            input_group { control } + tag.small(help_text, id: help_id, class: ['form-text', 'text-muted'])
          end
        end
      else
        tag.label(for: id, value: label, aria: { label: aria_label }) do
          label
        end +
          input_group { control } + tag.small(help_text, id: help_id, class: ['form-text', 'text-muted'])
      end
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

  def setting_value(setting)
    if setting && setting.is_a?(ResourceRegistry::Setting)
      JSON.parse(setting.item)
    else
      setting&.item
    end
  end
end