# frozen_string_literal: true

RSpec::Matchers.define :match_schema do |schema|
  match do |params|

    @result = schema.call(params)
    @result.success?
  rescue ArgumentError
    @result = {}
    false

  end

  def failure_message
    @result.errors || {}
  end
end
