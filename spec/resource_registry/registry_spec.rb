# frozen_string_literal: true

require "spec_helper"

RSpec.describe ResourceRegistry::Registry do

  let(:key)           { :my_registry }
  let(:name)          { :temporary_name }
  let(:root)          { Pathname.new('./lib') }
  let(:created_at)    { DateTime.now }
  let(:register_meta) { false }

  let(:configuration) { {
                          name: name,
                          root: root,
                          created_at: created_at,
                          register_meta: register_meta
                        }
                        }

  let(:options)       { { configuration: configuration } }
  let(:params)        { { key: key, options: options } }

  describe '#initialize' do
    let(:my_registry) { described_class.new(params) }
    let(:item_name)   { :name }
    let(:item)        { "my_registry" }

    it "should initialize a Registry object" do
      expect(my_registry).to be_a ResourceRegistry::Registry
    end

    it "and register and resolve an item" do
      my_registry.register(item_name, item)

      expect(my_registry.resolve(item_name)).to eq item
    end
  end

  describe 'DSL extensions' do
    before do
      class ::Greeter
        def call(params)
          return "Hello #{params}"
        end
      end
    end

    let(:key)               { :greeter_feature }
    let(:namespace)         { [:level_1, :level_2, :level_3 ]}
    let(:namespace_str)     { 'level_1.level_2.level_3'}
    let(:namespace_key)     { namespace_str + '.' + key.to_s }
    let(:is_enabled)        { false }
    let(:item)              { Greeter.new }

    let(:label)       { "Name of this UI Feature" }
    let(:type)        { :integer }
    let(:default)     { 42 }
    let(:value)       { 57 }
    let(:description) { "The Answer to Life, the Universe and Everything" }
    let(:enum)        { [] }
    let(:is_required) { false }
    let(:is_visible)  { false }

    let(:meta)        { { label: label,
                          type: type,
                          default: default,
                          value: value,
                          description: description,
                          enum: enum,
                          is_required: is_required,
                          is_visible: is_visible,
                          }
                        }

    let(:feature_hash)  { {
                            key: key,
                            namespace: namespace,
                            is_enabled: is_enabled,
                            item: item,
                            meta: meta,
                          }
                          }
    let(:feature)       { ResourceRegistry::Feature.new(feature_hash) }
    let(:registry)      { described_class.new(params) }

    describe '#register_feature' do
      context "given a new feature" do

        it "should register a feature" do
          expect(registry.register_feature(feature).keys).to include namespace_key
        end

        context "given an already-registered feature" do
          before { registry.register_feature(feature) }

          it "should raise an error" do
            expect{registry.register_feature(feature)}.to raise_error ResourceRegistry::Error::DuplicateFeatureError
          end
        end
      end
    end

    describe '#resolve_feature' do
      before { registry.register_feature(feature) }

      it "should resolve a feature key" do
        result = registry.resolve_feature(key)

        expect(result).to be_a ResourceRegistry::FeatureDSL
        expect(result.enabled?).to eq is_enabled
      end
    end

    describe '#feature_exist?' do
      before { registry.register_feature(feature) }

      context "given a registered feature key" do
        let(:feature_key) { key }

        it "should return true" do
          expect(registry.feature_exist?(feature_key)).to be_truthy
        end
      end

      context "given a non-registered feature key" do
        let(:feature_key) { :dummy_feature_key_name }

        it "should return false" do
          expect(registry.feature_exist?(feature_key)).to be_falsey
        end
      end
    end

    describe '#features' do
      let(:key_names) { (1..5).to_a.reduce([]) { |list, val| list << "greeter_feature_#{val}".to_sym } }

      before do
        key_names.each do | key_name |
          feature_hash.merge!(key: key_name)
          feature = ResourceRegistry::Feature.new(feature_hash)
          registry.register_feature(feature)
        end
      end

      it "returns all registered features" do
        list = registry.features

        expect(list.size).to eq key_names.size
        expect(list).to match_array key_names
      end
    end
  end
end
