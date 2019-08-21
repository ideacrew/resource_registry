# frozen_string_literal: true

require 'spec_helper'
require 'resource_registry/entities/feature'

RSpec.describe ResourceRegistry::Entities::Feature do

  subject { described_class.new(params) }

  context 'when valid feature hash passed' do
    let(:params) do
      {
        :key => :aca_shop_market,
        :is_required => false,
        :is_enabled => false,
        :alt_key => "shop",
        :title => "ACA SHOP Market",
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