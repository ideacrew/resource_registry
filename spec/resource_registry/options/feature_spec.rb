require "spec_helper"
require 'dry/container/stub'

RSpec.describe ResourceRegistry::Options::Feature do

  let(:key)         { :aca_shop_market }
  let(:title)       {  }
  let(:description) {  }
  let(:portal)      {  }
  let(:options)     { { option: { key: :color, default: "green", type: :string }} }


  let(:namespaces)  { [ 
                        namespace_root, 
                        namespace_other, 
                      ] }

  let(:namespace_other)             { ResourceRegistry::Options::OptionNamespace.new(
                                        namespace: :other, 
                                        options: []
                                      )}
  let(:namespace_root)              { ResourceRegistry::Options::OptionNamespace.new(
                                        namespace: :root, 
                                        namespaces: [namespace_child_a, namespace_child_b],
                                        options: []
                                      )}
  let(:namespace_child_a)           { ResourceRegistry::Options::OptionNamespace.new(
                                        namespace: :child_a, 
                                        namespaces: [namespace_grandchild_aa],
                                        options: []
                                      )}
  let(:namespace_child_b)           { ResourceRegistry::Options::OptionNamespace.new(
                                        namespace: :child_b, 
                                        options: []
                                      )}
  let(:namespace_grandchild_aa)     { ResourceRegistry::Options::OptionNamespace.new(
                                        namespace: :child_aa, 
                                        options: [namespace_grandchild_aa_child_aaa],
                                      )}
  let(:namespace_grandchild_aa_child_aaa)  { ResourceRegistry::Options::OptionNamespace.new(
                                        namespace: :child_aaa, 
                                        options: []
                                      )}

  let(:feature_hash)                  { {:key=>:aca_shop_market, :namespaces=>[{:namespace=>:root, :options=>[], :namespaces=>[{:namespace=>:child_a, :options=>[], :namespaces=>[{:namespace=>:child_aa, :options=>[{}]}]}, {:namespace=>:child_b, :options=>[]}]}, {:namespace=>:other, :options=>[]}]} }
  let(:namespace_root_hash)           { {:namespace=>:root, :options=>[], :namespaces=>[{:namespace=>:child_a, :options=>[], :namespaces=>[{:namespace=>:child_aa, :options=>[{}]}]}, {:namespace=>:child_b, :options=>[]}]} }

  subject { described_class.new }

  it "should do something" do
    expect(described_class.new(key: key, namespaces: namespaces).to_hash).to eq feature_hash
    expect(described_class.new(key: key, namespaces: namespaces).namespaces.first.to_hash).to eq namespace_root_hash
  end

# ResourceRegistry::Options::Feature.new(key: :aca_shop_market, namespaces: {name: 'test',  options: [ {key: :color, default: "green", type: :string}]})

end