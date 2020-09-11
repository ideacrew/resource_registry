# frozen_string_literal: true

require 'spec_helper'
require 'resource_registry/entities/tenant'

RSpec.describe ResourceRegistry::Entities::Tenant do

  subject { described_class.new(params) }

  context 'when valid tenant hash passed' do
    let(:params) do
      {:key => :dchbx,
       :organization_name => "DC Health Benefit Exchange Authority",
       :owner_account_name => "admin@hbx_org.com",
       :sites =>
         [{:key => :shop_site,
           :parent_key => :shop_site,
           :url => "https://shop.openhbx.org",
           :title => "ACA SHOP market",
           :description => "shop market",
           :environments =>
            [{:key => :production,
              :features =>
               [{:key => :enroll_app,
                :parent_key => :enroll_app,
                 :is_required => false,
                 :is_enabled => false,
                 :alt_key => "ea",
                 :title => "Enroll Application Component",
                 :description => "A streamlined, end-to-end technology for employers, employees and individuals to sponsor, shop and enroll in insurance benefits"}],
              :options =>
               [{:key => :settings,
                 :settings =>
                  [
                    {:key => "copyright_period_start", :type => :string, :default => "2013"},
                    {:key => "nondiscrimination_notice_url", :type => :string, :default => "https://www.dchealthlink.com/nondiscrimination"}
                  ]}]}]}]}
    end

    it 'should build tenant object' do
      expect(subject).to be_instance_of(described_class)
    end
  end
end
