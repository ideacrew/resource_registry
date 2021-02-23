# frozen_string_literal: true

module InputControls
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
end
