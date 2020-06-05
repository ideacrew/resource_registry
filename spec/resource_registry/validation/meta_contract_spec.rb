# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Validation::MetaContract do

  let(:label)       { "Name of this UI Feature" }
  let(:type)        { :integer }
  let(:default)     { 42 }
  let(:value)       { 57 }
  let(:description) { "The Answer to Life, the Universe and Everything" }
  let(:enum)        { [] }
  let(:is_required) { false }
  let(:is_visible)  { false }

  let(:required_params)   { { label: label, type: type, default: default, } }
  let(:optional_params)   { {
                              value: value,
                              description: description,
                              enum: enum,
                              is_required: is_required,
                              is_visible: is_visible,
                            }
                            }
  let(:all_params)        { required_params.merge(optional_params) }                            

  context "Validation with invalid input" do
    let (:required_params_error) { {:default=>["is missing"], :label=>["is missing"], :type=>["is missing"]} }

    context "Given hash params are empty" do

      it { expect(subject.call({}).failure?).to be_truthy }
      it { expect(subject.call({}).errors.to_h).to eq required_params_error }
    end

    context "Given hash params include only optional attributes" do
      it { expect(subject.call(optional_params).failure?).to be_truthy }
      it { expect(subject.call(optional_params).errors.to_h).to eq required_params_error }
    end
  end

  context "Validation with valid input" do
    context "Given hash params include required attributes" do
      it "should pass validation" do
        expect(subject.call(required_params).success?).to be_truthy
        expect(subject.call(required_params).to_h).to eq required_params
      end
    end

    context "Given hash params include all required nd optional attributes" do
      it "should pass validation" do
        expect(subject.call(all_params).success?).to be_truthy
        expect(subject.call(all_params).to_h).to eq all_params
      end
    end
  end

  context 'when valid feature hash passed' do
    let(:params) do
      {
        :key => :aca_shop_market,
        :is_required => false,
        :is_enabled => false,
        :alt_key => "shop",
        :label => "ACA SHOP Market",
        :description => "ACA Small Business Health Options (SHOP) Portal",
        :options =>
        [{:key => :settings,
          :settings =>
          [{:key => "small_market_employee_count_maximumt", :type => :integer, :default => 50},
           {:key => "employer_contribution_percent_minimum", :type => :integer, :default => 50},
           {:key => "employer_dental_contribution_percent_minimumt", :type => :integer, :default => 0},
           {:key => "employer_family_contribution_percent_minimum", :type => :integer, :default => 0}]},
         {:key => :benefit_market_catalog_2017,
          :namespaces =>
          [{:key => :month_1,
            :settings =>
            [{:key => :open_enrollment_begin_dom, :type => :integer, :default => 1},
             {:key => :open_enrollment_end_dom, :type => :integer, :default => 20},
             {:key => :binder_payment_due_dom, :type => :integer, :default => 23}]},
           {:key => :month_2,
            :settings =>
            [{:key => :open_enrollment_begin_dom, :type => :integer, :default => 1},
             {:key => :open_enrollment_end_dom, :type => :integer, :default => 20},
             {:key => :binder_payment_due_dom, :type => :integer, :default => 23}]}]}]
      }
    end

    it 'should build feature object' do
      expect(subject).to be_instance_of(described_class)
    end
  end

end
