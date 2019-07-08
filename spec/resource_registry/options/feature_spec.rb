require "spec_helper"
require 'dry/container/stub'

RSpec.describe ResourceRegistry::Options::Feature do

  let(:key)         { :aca_shop_market }
  let(:title)       {  }
  let(:description) {  }
  let(:portal)      {  }
  let(:options)     { { option: { key: :color, default: "green", type: :string }} }

  subject { described_class.new }

  it "should do something" do
    expect(subject(key: key)).to be_nil
  end


# ResourceRegistry::Options::Feature.new(key: :aca_shop_market, namespaces: {name: 'test',  options: [ {key: :color, default: "green", type: :string}]})

end