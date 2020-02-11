# frozen_string_literal: true

require "spec_helper"

RSpec.describe ResourceRegistry::Features do

  describe "#configure" do
    let(:enabled_key)     { :enabled }
    let(:enabled_option)  { [:enroll_app, :aca_shop_market, :aca_individual_market, :fehb_market] }
    let(:enabled_default) { { default: enabled_option } }

    let(:logger_key)      { :logger }
    let(:logger_option)   { Logger.new(STDERR, :warn) }
    let(:logger_default)  { { default: logger_option } }

    context "a setting is passed with options hash including :default key" do

      before do
        subject.configure(enabled_key, enabled_default)
      end

      it "stores configuration value for passed key" do
        enabled_value = subject.configuration[enabled_key]

        expect(enabled_value).to be_a Array
        expect(enabled_value).to eq enabled_option
        expect(subject).to respond_to enabled_key

      end

      it "stores default value for passed key" do
        expect(subject.defaults[enabled_key]). to eq enabled_option
      end

      it "creates a getter and setter method for the passed key" do
        expect(subject).to respond_to enabled_key
      end


      context "and the setting value is updated" do
        let(:updated_enabled_option)  { [:enroll_app] }

        before do
          # subject.configure(enabled_key, updated_enabled_option)
        end

        it "the configuration value should update" do
        end
      end
    end


    context '#arguments as a block' do

      before do
        # binding.pry
        subject.configuration do |config|
          config(enabled_key, enabled_option)
          config(logger_key, logger_option)
        end
      end

      it 'should set defaults' do
      end
    end

  end

end
