# frozen_string_literal: true

require_relative 'input_controls'
require_relative 'date_controls'
# Helper methods to render interface from features/settings
module FormGroupControls
  include ::InputControls
  include ::DateControls

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
      form_group(option, input_control, attrs)
    end
  end

  # Build a general-purpose form group wrapper around the supplied input control
  def form_group(setting, control, options = {})
    id          = setting[:key].to_s
    # label       = setting[:title] || id.titleize
    label       = setting.meta.label || id.titleize
    help_id     = "#{id}HelpBlock"
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
              tag.i(class: 'fas fa-info-circle', rel: 'tooltip', title: setting.meta.description)
            end +
            tag.div(class: 'col col-sm-12 col-md-7') do
              input_group { control } # + tag.small(help_text, id: help_id, class: ['form-text', 'text-muted'])
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
    help_id     = "#{id}HelpBlock"
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
end