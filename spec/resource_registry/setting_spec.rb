require "spec_helper"

RSpec.describe ResourceRegistry::Setting do

  let(:collection_set_name)   { :enroll_app }
  let(:namespace)             { :ui }
  let(:key)                   { :copyright_period_start_year }
  let(:title)                 { "Copyright Period Start Year"}
  let(:description)           { "The initial calendar year (YYYY) that site content copyright is asserted" }
  let(:type)                  { :string }
  let(:value)                 { "2018" }
  let(:default)               { "::TimeKeeper.date_of_record.year" }

  let(:params) do {
      collection_set_name: collection_set_name,
      namespace: namespace,
      key: key,
      meta: {
        title: title,
        description: description,
        type: type,
        value: value,
        default: default,        
      },
    }
  end

  subject { described_class.new(params) }


  describe "Attributes and restrictions" do
    it { expect(subject).to be_a Dry::Struct }

    it { expect(subject[:collection_set_name]).to eq collection_set_name }
    it { expect(subject[:namespace]).to eq namespace }
    it { expect(subject[:key]).to eq key }

    it { expect(subject[:meta][:title]).to eq title }
    it { expect(subject[:meta][:description]).to eq description }
    it { expect(subject[:meta][:type]).to eq type }
    it { expect(subject[:meta][:default]).to eq default }
    it { expect(subject[:meta][:value]).to eq value }

    context "without an optional namespace attribute value" do
      subject { described_class.new(params.except(:namespace).valid?).to be_truthy }
    end

    # context "without a title paramater" do
    #   subject { described_class.new(params.tap { |p| p[:meta].tap { |m| m.delete(:title) } }).valid?  }
    #   subject { described_class.new(params.tap { |p| p[:meta].tap { |m| m.delete(:title) } }) }

    #   it { expect(subject[:meta][:title]).to eq subject }


    # end

  end

end
