# frozen_string_literal: true

RSpec::Matchers.define :match_schema do |schema|
  match do |params|
    begin
      @result = schema.call(params)
      @result.success?
    rescue ArgumentError
      @result = {}
      false
    end
  end

  def failure_message
    @result.errors || {}
  end
end
