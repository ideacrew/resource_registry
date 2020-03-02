# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Enterprises::Create do

  subject { described_class.new.call(enterprise_hash) }

    let(:enterprise_hash) do
      {
        enterprise: {
          :tenants =>
           [{ 
              :key => :dchbx,
              :organization_name => "DC Health Benefit Exchange Authority",
              :owner_account_name => "admin@hbx_org.com",
              :sites =>
               [{:key => :shop_site,
                 :url => "https://shop.openhbx.org",
                 :title => "ACA SHOP market",
                 :description => "shop market",
                 :environments =>
                  [{:key => environment,
                    :features =>
                     [{:key => :enroll_app,
                       :parent_key => :enroll_app,
                       :is_required => false,
                       :is_enabled => false,
                       :alt_key => "ea",
                       :title => "Enroll Application Component",
                       :description => "A streamlined, end-to-end technology for employers, employees and individuals to sponsor, shop and enroll in insurance benefits"}]
                  }]}]
            }]
        }
      }
    end

  context 'when enterpise hash is valid' do
    let(:environment) { :production }

    it 'should build enterprise object' do
      expect(subject.success?).to be_truthy
      expect(subject.value!).to be_instance_of(ResourceRegistry::Entities::Enterprise)
    end
  end

  context 'when enterpise hash invalid' do 
    let(:environment) { :preprod }

    it 'should fail with validation error' do
      expect(subject.success?).to be_falsey
      expect(subject.failure).to be_instance_of(Dry::Validation::MessageSet)
    end
  end
end