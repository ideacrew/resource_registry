# frozen_string_literal: true

# Helper methods to render setting date fields
module DateControls

  def input_date_control(setting, form)
    id = setting[:key].to_s

    date_value = value_for(setting, form)
    date_value = date_value.to_date if date_value.is_a?(Time)
    date_value = date_value.to_s(:db) if date_value.is_a?(Date)

    meta = setting[:meta]
    input_value = date_value || setting.item || meta&.default
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
end