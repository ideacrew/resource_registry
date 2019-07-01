require "spec_helper"

RSpec.describe ResourceRegistry::Setting do

  let(:key)           { :copyright_period_start_year }
  let(:title)         { "Copyright Period Start Year"}
  let(:description)   { "The initial calendar year (YYYY) that site content copyright is asserted" }
  let(:type)          { :string }
  let(:value)         { 2018 }
  let(:default)       { "::TimeKeeper.date_of_record.year" }

  let(:params) do {
      key: key,
      title: title,
      description: description,
      type: type,
      value: value,
      default: default,
    }
  end

  subject { described_class.new(params) }


  describe "Attributes and restrictions" do

    it { expect(subject).to be_a Dry::Struct }

  end

end
