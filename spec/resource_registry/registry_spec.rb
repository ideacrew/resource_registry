# frozen_string_literal: true

require "spec_helper"

RSpec.describe ResourceRegistry::Registry do

  let(:key)           { :my_registry }
  let(:name)          { :temporary_name }
  let(:root)          { Pathname.new('./lib') }
  let(:created_at)    { DateTime.now }
  let(:register_meta) { false }

  let(:configuration) do
    {
      name: name,
      root: root,
      created_at: created_at,
      register_meta: register_meta
    }
  end

  let(:options)       { { configuration: configuration } }
  # let(:params)        { { key: key, options: options } }

  describe '#initialize' do
    let(:my_registry) { described_class.new }
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

  describe '#configure' do
    let(:my_registry) { described_class.new }

    before do
      my_registry.configure do |config|
        config.name       = :enroll
        config.created_at = DateTime.now
      end
    end

  end

  describe 'DSL extensions' do
    before do
      module ResourceRegistry
        class Greeter
          def call(params)
            "Hello #{params}"
          end
        end
      end
    end

    let(:key)               { :greeter_feature }
    let(:namespace)         { [:level_1, :level_2, :level_3]}
    let(:namespace_str)     { 'level_1.level_2.level_3'}
    let(:namespace_key)     { namespace_str + '.' + key.to_s }
    let(:is_enabled)        { false }
    let(:item)              { ResourceRegistry::Greeter.new }

    let(:label)       { "Name of this UI Feature" }
    let(:type)        { :integer }
    let(:default)     { 42 }
    let(:value)       { 57 }
    let(:description) { "The Answer to Life, the Universe and Everything" }
    let(:enum)        { [] }
    let(:is_required) { false }
    let(:is_visible)  { false }

    let(:meta) do
      {
        label: label,
        type: type,
        default: default,
        value: value,
        description: description,
        enum: enum,
        is_required: is_required,
        is_visible: is_visible
      }
    end

    let(:feature_hash) do
      {
        key: key,
        namespace: namespace,
        is_enabled: is_enabled,
        item: item,
        meta: meta
      }
    end
    let(:feature)       { ResourceRegistry::Feature.new(feature_hash) }
    let(:registry)      { described_class.new }

    describe '#register_feature' do

      context "passing a non-feature class argument" do
        let(:non_feature) { "feature poser" }

        it "should raise an error" do
          expect{registry.register_feature(non_feature)}.to raise_error ArgumentError
        end

      end

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

      context "given feature with no namespace" do
        let(:namespace) { [] }

        it "should register feature under root" do
          registry.register_feature(feature)

          expect(registry.keys).to include "feature_index.#{feature.key}"
          expect(registry.keys).to include feature.key.to_s
        end
      end
    end

    describe '#resolve_feature' do

      context "given a key for an unregistered feature" do
        let(:unregistered_feature)  { :unregistered_feature  }

        it "should raise an error" do
          expect{registry.resolve_feature(unregistered_feature)}.to raise_error ResourceRegistry::Error::FeatureNotFoundError
        end
      end

      context "given a key for a registered feature" do
        let(:block_text) { "Dolly" }
        let(:is_enabled) { true }

        before { registry.register_feature(feature) }

        it "should resolve a feature key" do
          result = registry.resolve_feature(key)

          expect(result).to be_a ResourceRegistry::FeatureDSL
          expect(result.enabled?).to eq is_enabled
        end

        it "should support shortcut syntax" do
          expect(registry[key.to_sym]).to eq registry.resolve_feature(key)
        end

        it "should accept a block and pass to a registered class" do
          expect(registry[key] { block_text }).to eq "Hello Dolly"
        end

      end
    end

    describe '#feature?' do
      before { registry.register_feature(feature) }

      context "given a registered feature key" do
        let(:feature_key) { key }

        it "should return true" do
          expect(registry.feature?(feature_key)).to be_truthy
        end
      end

      context "given a non-registered feature key" do
        let(:feature_key) { :dummy_feature_key_name }

        it "should return false" do
          expect(registry.feature?(feature_key)).to be_falsey
        end
      end
    end

    describe '#features' do
      let(:key_names) { (1..5).to_a.reduce([]) { |list, val| list << "greeter_feature_#{val}".to_sym } }

      before do
        key_names.each do |key_name|
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

    describe '#enabled?' do
      context "Given features without a namespace that is enabled" do
        let(:vessel) { ResourceRegistry::Feature.new(key: :vessel, is_enabled: true) }

        before { registry.register_feature(vessel) }

        it "the feature should be enabled" do
          expect(registry.feature_enabled?(:vessel)).to be_truthy
        end
      end

      context "Given an enabled feature with all ancestors enabled" do
        let(:boat) do
          ResourceRegistry::Feature.new(key: :boat,
                                        namespace: [:vessel],
                                        is_enabled: true)
        end

        let(:sailboat) do
          ResourceRegistry::Feature.new(key: :sailboat,
                                        namespace: [:vessel, :boat],
                                        is_enabled: true)
        end

        before do
          registry.register_feature(boat)
          registry.register_feature(sailboat)
        end

        it "the feature should be enabled" do
          expect(registry.feature_enabled?(:boat)).to be_truthy
        end


        it "the child feature should be enabled" do
          expect(registry.feature_enabled?(:sailboat)).to be_truthy
        end


        context "and an enabled feature with a break in ancestor namespace" do
          let(:canoe) do
            ResourceRegistry::Feature.new(key: :canoe,
                                          namespace: [:vessel, :boat, :paddleboat],
                                          is_enabled: false)
          end
          before { registry.register_feature(canoe) }

          it "the child feature should be enabled" do
            expect(registry.feature_enabled?(:sailboat)).to be_truthy
          end
        end

      end

      context "Given an ancestor feature is disabled" do
        let(:powerboat) do
          ResourceRegistry::Feature.new(key: :powerboat,
                                        namespace: [:vessel, :boat],
                                        is_enabled: false)
        end

        context "and a child of that feature is enabled" do
          let(:trawler) do
            ResourceRegistry::Feature.new(key: :trawler,
                                          namespace: [:vessel, :boat, :powerboat],
                                          is_enabled: true)
          end

          before do
            registry.register_feature(powerboat)
            registry.register_feature(trawler)
          end

          it "the child feature should be disabled" do
            expect(registry.feature_enabled?(:trawler)).to be_falsey
          end

        end
      end
    end

    describe '#parent_namespace' do
      let(:parent_namespace)  { 'ns_0.ns_1' }
      let(:child_feature)     { 'ns_0.ns_1.ns_2' }

      it 'should find the parent' do
        expect(registry.send(:parent_namespace, child_feature)).to eq parent_namespace
      end
    end

    describe '#features_by_namespace' do
      context "Given features registered in different namespaces" do
        let(:sail_ns) { [:vessel, :boat, :sail] }
        let(:sail_ns_str) { sail_ns.map(&:to_s).join('.') }
        let(:boat_ns) { [:vessel, :boat] }
        let(:boat_ns_str) { boat_ns.map(&:to_s).join('.') }


        let(:ski)     { ResourceRegistry::Feature.new(key: :ski, namespace: boat_ns, is_enabled: true) }
        let(:trawler) { ResourceRegistry::Feature.new(key: :trawler, namespace: boat_ns, is_enabled: true) }
        let(:sloop)   { ResourceRegistry::Feature.new(key: :sloop, namespace: sail_ns, is_enabled: true) }
        let(:ketch)   { ResourceRegistry::Feature.new(key: :ketch, namespace: sail_ns, is_enabled: true) }
        let(:yawl)    { ResourceRegistry::Feature.new(key: :yawl, namespace: sail_ns, is_enabled: true) }

        let(:sail_features) { [:sloop, :ketch, :yawl] }
        let(:boat_features) { [:ski, :trawler] }

        before do
          registry.register_feature(ski)
          registry.register_feature(trawler)
          registry.register_feature(sloop)
          registry.register_feature(ketch)
          registry.register_feature(yawl)
        end

        it 'should return only features for the first namespace' do
          expect(registry.features_by_namespace(sail_ns_str)).to eq sail_features
        end

        it 'should return only features for the second namespace' do
          expect(registry.features_by_namespace(boat_ns_str)).to eq boat_features
        end
      end
    end


    describe '#configuration methods' do
      let(:name_val)        { :enroll }
      let(:load_path)       { 'system/templates' }
      let(:created_at)      { DateTime.now.freeze }
      let(:register_meta)   { false }

      let(:config_params) { { name: name_val, load_path: load_path, created_at: created_at, register_meta: register_meta } }

      let(:config_registry) { described_class.new }

      before do
        config_registry.configure do |conf|
          conf.name       = name_val
          conf.load_path  = load_path
          conf.created_at = created_at
        end
      end

      describe '#configurations' do
        it 'should return all registry configuration params' do
          expect(config_registry.configurations).to eq config_params
        end
      end

      describe '#configuration' do
        let(:invalid_attribute)   { :not_a_confg_attribute }

        it "should return value for the referenced registry configuration attribute" do
          expect(config_registry.configuration(:name)).to eq name_val
          expect(config_registry.configuration(:load_path)).to eq load_path
          expect(config_registry.configuration(:created_at)).to eq created_at
        end

        it "should raise an error for an invalid registry configuration attribute key" do
          expect{config_registry.configuration(invalid_attribute)}.to raise_error do |error|
            is_expected_error = error.is_a?(Dry::Container::Error) || error.is_a?(Dry::Container::KeyError)
            expect(is_expected_error).to be_truthy
          end
        end

      end
    end
    describe "#feature_enabled?" do
      context "Given features registered in different namespaces" do
        let(:sail_ns) { %i[vessel boat sail] }
        let(:sail_ns_str) { sail_ns.map(&:to_s).join(".") }
        let(:boat_ns) { %i[vessel boat] }
        let(:boat_ns_str) { boat_ns.map(&:to_s).join(".") }

        let(:vessel) do
          ResourceRegistry::Feature.new(
            key: :vessel,
            namespace: [],
            is_enabled: vessel_enabled
          )
        end

        let(:boat) do
          ResourceRegistry::Feature.new(
            key: :boat,
            namespace: [:vessel],
            is_enabled: boat_enabled
          )
        end

        let(:sail) do
          ResourceRegistry::Feature.new(
            key: :sail,
            namespace: [:vessel],
            is_enabled: sail_enabled
          )
        end

        let(:ski) do
          ResourceRegistry::Feature.new(
            key: :ski,
            namespace: boat_ns,
            is_enabled: true
          )
        end
        let(:trawler) do
          ResourceRegistry::Feature.new(
            key: :trawler,
            namespace: boat_ns,
            is_enabled: true
          )
        end
        let(:sloop) do
          ResourceRegistry::Feature.new(
            key: :sloop,
            namespace: sail_ns,
            is_enabled: true
          )
        end
        let(:ketch) do
          ResourceRegistry::Feature.new(
            key: :ketch,
            namespace: sail_ns,
            is_enabled: true
          )
        end
        let(:yawl) do
          ResourceRegistry::Feature.new(
            key: :yawl,
            namespace: sail_ns,
            is_enabled: true
          )
        end

        let(:sail_features) { [sloop, ketch, yawl] }
        let(:boat_features) { [ski, trawler] }

        before do
          registry.register_feature(vessel)
          registry.register_feature(boat)
          registry.register_feature(sail)
          registry.register_feature(ski)
          registry.register_feature(trawler)
          registry.register_feature(sloop)
          registry.register_feature(ketch)
          registry.register_feature(yawl)
        end

        context 'when the boat disabled and sail enabled' do
          let(:vessel_enabled) { true }
          let(:boat_enabled) { false }
          let(:sail_enabled) { true }

          it 'should return false for all features with boat namespace' do
            expect(registry.feature_enabled?(:vessel)).to be_truthy
            expect(registry.feature_enabled?(:boat)).to be_falsey
            boat_features.each do |feature|
              expect(registry.feature_enabled?(feature.key)).to be_falsey
            end

            expect(registry.feature_enabled?(:sail)).to be_truthy
            sail_features.each do |feature|
              expect(registry.feature_enabled?(feature.key)).to be_falsey
            end
          end
        end

        context 'when the sail disabled and boat enabled' do
          let(:vessel_enabled) { true }
          let(:boat_enabled) { true }
          let(:sail_enabled) { false }

          it 'should return false for all features under sail namespace' do
            expect(registry.feature_enabled?(:vessel)).to be_truthy
            expect(registry.feature_enabled?(:sail)).to be_falsey
            sail_features.each do |feature|
              expect(registry.feature_enabled?(feature.key)).to be_falsey
            end

            expect(registry.feature_enabled?(:boat)).to be_truthy
            boat_features.each do |feature|
              expect(registry.feature_enabled?(feature.key)).to be_truthy
            end
          end
        end

        context 'when the vessel disabled' do
          let(:vessel_enabled) { false }
          let(:boat_enabled) { true }
          let(:sail_enabled) { true }

          it 'should return false for all features' do
            expect(registry.feature_enabled?(:vessel)).to be_falsey
            expect(registry.feature_enabled?(:sail)).to be_falsey
            sail_features.each do |feature|
              expect(registry.feature_enabled?(feature.key)).to be_falsey
            end

            expect(registry.feature_enabled?(:boat)).to be_falsey
            boat_features.each do |feature|
              expect(registry.feature_enabled?(feature.key)).to be_falsey
            end
          end
        end
      end
    end
  end
end
