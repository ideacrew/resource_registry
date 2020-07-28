# frozen_string_literal: true

require 'spec_helper'
require 'resource_registry/entities/option'

RSpec.describe ResourceRegistry::Entities::Option do

  subject { described_class.new(params) }

  context 'when valid option hash passed' do
    let(:params) do
      {:key => :benefit_market_catalog_2017,
       :namespaces =>
        [
          {:key => :month_1,
           :settings =>
            [
              {:key => :open_enrollment_begin_dom, :type => :integer, :default => 1},
              {:key => :open_enrollment_end_dom, :type => :integer, :default => 20},
              {:key => :binder_payment_due_dom, :type => :integer, :default => 23}
            ]},
          {:key => :month_2,
           :settings =>
            [
              {:key => :open_enrollment_begin_dom, :type => :integer, :default => 1},
              {:key => :open_enrollment_end_dom, :type => :integer, :default => 20},
              {:key => :binder_payment_due_dom, :type => :integer, :default => 23}
            ]}
        ]}
    end

    it 'should build option object' do
      expect(subject).to be_instance_of(described_class)
    end
  end
end
