require "spec_helper"
require 'dry/container/stub'

RSpec.describe ResourceRegistry::Options::Feature do

  let(:key)         { :aca_shop_market }
  let(:title)       {  }
  let(:description) {  }
  let(:portal)      {  }

  let(:options)     { 
     options_with_no_children  + 
     options_with_one_children + 
     options_with_two_children + 
     options_with_three_children
  }

  let(:options_with_no_children) { 
    [
      ResourceRegistry::Options::Option.new(key: :small_market_employee_count_maximum, default: "50", type: :integer),
      ResourceRegistry::Options::Option.new(key: :small_market_active_employee_limit, default: "200", type: :integer)
    ]
  }

  let(:options_with_one_children) { 
    [
      ResourceRegistry::Options::Option.new({
        key: :earliest_enroll_prior_to_effective_on, 
        options: [
          ResourceRegistry::Options::Option.new(key: :days, default: "-30", type: :integer)
        ]
      }),
      ResourceRegistry::Options::Option.new({
        key: :latest_enroll_after_effective_on, 
        options: [
          ResourceRegistry::Options::Option.new(key: :days, default: "30", type: :integer)
        ]
      })
    ]
  }

  let(:options_with_two_children) { 
    [
      ResourceRegistry::Options::Option.new({
        key: :initial_application,
        options: [
          ResourceRegistry::Options::Option.new({
            key: :earliest_start_prior_to_effective_on,
            options: [
              ResourceRegistry::Options::Option.new(key: :months, default: "-3", type: :integer),
              ResourceRegistry::Options::Option.new(key: :day_of_month, default: "0", type: :integer)
            ]
          }),
          ResourceRegistry::Options::Option.new({
            key: :appeal_period_after_application_denial,
            options: [
              ResourceRegistry::Options::Option.new(key: :days, default: "30", type: :integer)
            ]
          }),   
        ]
      })
    ]
  }

  let(:options_with_three_children) { 
    [
      ResourceRegistry::Options::Option.new({
        key: :renewal_application,
        options: [
          ResourceRegistry::Options::Option.new({
            key: :open_enrollment,
            options: [
              ResourceRegistry::Options::Option.new({
                key: :minimum_length,
                options: [
                  ResourceRegistry::Options::Option.new(key: :days, default: "3", type: :integer)
                ]
              })
            ]
          })
        ]
      })
    ]
  }


  subject { described_class.new(key: key, options: options) }

  it 'should build container' do 
    container = Dry::Container.new
    container.namespace(:aca_shop) do |shop_ns|
      subject.load!(shop_ns)
    end
  end

  # let(:namespaces)  { [ 
  #                       namespace_root, 
  #                       namespace_other, 
  #                     ] }

  # let(:namespace_other)             { ResourceRegistry::Options::OptionNamespace.new(
  #                                       namespace: :other, 
  #                                       options: []
  #                                     )}
  # let(:namespace_root)              { ResourceRegistry::Options::OptionNamespace.new(
  #                                       namespace: :root, 
  #                                       namespaces: [namespace_child_a, namespace_child_b],
  #                                       options: []
  #                                     )}
  # let(:namespace_child_a)           { ResourceRegistry::Options::OptionNamespace.new(
  #                                       namespace: :child_a, 
  #                                       namespaces: [namespace_grandchild_aa],
  #                                       options: []
  #                                     )}
  # let(:namespace_child_b)           { ResourceRegistry::Options::OptionNamespace.new(
  #                                       namespace: :child_b, 
  #                                       options: []
  #                                     )}
  # let(:namespace_grandchild_aa)     { ResourceRegistry::Options::OptionNamespace.new(
  #                                       namespace: :child_aa, 
  #                                       options: [namespace_grandchild_aa_child_aaa],
  #                                     )}
  # let(:namespace_grandchild_aa_child_aaa)  { ResourceRegistry::Options::OptionNamespace.new(
  #                                       namespace: :child_aaa, 
  #                                       options: []
  #                                     )}

  # let(:feature_hash)                  { {:key=>:aca_shop_market, :namespaces=>[{:namespace=>:root, :options=>[], :namespaces=>[{:namespace=>:child_a, :options=>[], :namespaces=>[{:namespace=>:child_aa, :options=>[{}]}]}, {:namespace=>:child_b, :options=>[]}]}, {:namespace=>:other, :options=>[]}]} }
  # let(:namespace_root_hash)           { {:namespace=>:root, :options=>[], :namespaces=>[{:namespace=>:child_a, :options=>[], :namespaces=>[{:namespace=>:child_aa, :options=>[{}]}]}, {:namespace=>:child_b, :options=>[]}]} }

  # subject { described_class.new }

  # it "should do something" do
  #   expect(described_class.new(key: key, namespaces: namespaces).to_hash).to eq feature_hash
  #   expect(described_class.new(key: key, namespaces: namespaces).namespaces.first.to_hash).to eq namespace_root_hash
  # end

  # ResourceRegistry::Options::Feature.new(key: :aca_shop_market, namespaces: {name: 'test',  options: [ {key: :color, default: "green", type: :string}]})

end