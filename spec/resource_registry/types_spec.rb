require "spec_helper"
require 'resource_registry/types'

RSpec.describe ResourceRegistry::Types do

  let(:rails_6_month_duration)   { ActiveSupport::Duration.build(6.months) }
  let(:rails_3_day_duration)     { ActiveSupport::Duration.build(3.days) }

  subject(:type) { ResourceRegistry::Types::Duration }

  it 'responds_to Rails Duration method' do
    expect(type[rails_6_month_duration]).to respond_to :from_now
  end

  it 'definition supports callable (proc) interface' do
    expect(ResourceRegistry::Types::Callable.valid?(type)).to be_truthy
  end

  it 'coerces to a Rails Duration' do
    expect(type[3.days]).to eql(rails_3_day_duration)
  end

end

