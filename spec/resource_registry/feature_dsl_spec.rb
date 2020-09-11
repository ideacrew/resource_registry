# frozen_string_literal: true

require "spec_helper"

RSpec.describe ResourceRegistry::FeatureDSL do

  before do
    class ::Greeter
      def call(params)
        "Hello #{params[:name]}"
      end
    end
  end

  let(:key)         { :greeter_feature }
  let(:namespace)   { [:level_1, :level_2, :level_3]}
  let(:is_enabled)  { false }
  let(:item)        { Greeter.method(:new) }
  let(:options)     { { name: "Dolly" } }

  let(:default)     { 42 }
  let(:label)       { "Feature Label" }
  let(:type)        { :integer }
  let(:meta)        { { label: label, default: default, type: type } }

  let(:settings)    { [{ key: :service, item: "weather/forecast" }, { key: :retries, item: 4 }] }


  let(:min_feature_hash) do
    {
      key: key,
      namespace: namespace,
      is_enabled: is_enabled,
      item: item
    }
  end

  let(:feature_hash) do
    {
      key: key,
      namespace: namespace,
      is_enabled: is_enabled,
      item: item,
      options: options,
      meta: meta,
      settings: settings
    }
  end

  let(:feature) { ResourceRegistry::Feature.new(feature_hash) }


  describe "initialize" do
    it 'sets feature' do
      dsl = described_class.new(feature)
      expect(dsl.feature) == feature
    end
  end

  describe 'DSL methods' do
    let(:dsl) { described_class.new(feature) }

    describe '#enabled/disabled' do
      it "correctly reports feature's state" do
        expect(dsl.feature.is_enabled).to be_falsey

        expect(dsl.enabled?).to be_falsey
        expect(dsl.disabled?).to be_truthy
      end
    end

    describe '#namespace' do
      let(:ns_string) { 'level_1.level_2.level_3' }

      it "correctly returns feature's namespace in stringified dot notation" do
        expect(dsl.namespace).to eq ns_string
      end
    end

    describe '#settings' do

      context "and settings are not present" do
        let(:feature_hash_sans_settings)  { min_feature_hash }
        let(:feature_sans_settings)       { ResourceRegistry::Feature.new(feature_hash_sans_settings) }
        let(:dsl_sans_settings)           { described_class.new(feature_sans_settings) }

        it "should return an empty array" do
          expect(dsl_sans_settings.settings).to eq []
        end
      end

      context "and settings are present" do
        let(:settings_entities) do
          settings.reduce([]) do |list, setting|
            list << ResourceRegistry::Setting.new(setting)
          end
        end

        it "correctly returns all settings for a feature" do
          expect(dsl.settings).to eq settings_entities
        end

        describe '#setting' do
          let(:first_setting)     { settings_entities.first }
          let(:first_setting_id)  { first_setting.key }

          it "correctly returns an individual setting for a feature" do
            expect(dsl.setting(first_setting_id)).to eq first_setting
          end

          it "returns nil if named setting isn't found" do
            expect(dsl.setting(:no_such_setting_id)).to eq nil
          end
        end
      end
    end

    describe '#default_value' do

      context "and meta is present" do
        context "and default is present" do
          it "should find the attribute value in the meta hash" do
            expect(dsl.default_value).to eq default
          end
        end

        context "and meta key is not present" do
          let(:missing_key) { :enumerations }

          it "should return nil value" do
            expect(dsl.send(missing_key)).to eq nil
          end
        end
      end

      context "and meta is not present" do
        let(:feature_hash_sans_meta) { min_feature_hash }
        let(:feature_sans_meta) { ResourceRegistry::Feature.new(feature_hash_sans_meta) }
        let(:dsl_sans_meta)     { described_class.new(feature_sans_meta) }

        it "should return an empty hash" do
          expect(dsl_sans_meta.meta).to eq Hash.new
        end

        context "and meta key is not present" do
          it "should return nil value" do
            expect(dsl.default_value).to eq default
          end
        end

      end
    end
  end

  describe "features" do
  end

end
