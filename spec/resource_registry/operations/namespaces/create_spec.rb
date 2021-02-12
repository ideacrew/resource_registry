# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ResourceRegistry::Operations::Namespaces::Create do
  include RegistryDataSeed

  subject { described_class.new.call(params) }

  let(:feature) {
    ResourceRegistry::Feature.new({
      :key => :health_packages,
      :namespace_path => {
        :path => [:dchbx, :enroll_app, :aca_shop_market],
        :meta => {
          :label => "ACA Shop",
          :content_type => :feature_list,
          :is_required => true,
          :is_visible => true
        }
      },
      :is_enabled => true,
      :item => :features_display,
      :meta => {
        :label => "Health Packages",
        :content_type => :legend,
        :is_required => true,
        :is_visible => true
      },
    })
  }

  context 'When valid params passed' do
    let(:params) {
      {
        key: feature.namespace_path.path.map(&:to_s).join('_'),
        path: feature.namespace_path.path,
        feature_keys: [feature.key],
        meta: feature.namespace_path.meta.to_h
      }
    }

    it "should return namespace entity" do
      subject
      expect(subject).to be_a Dry::Monads::Result::Success
      expect(subject.success).to be_a ResourceRegistry::Namespace
    end
  end

  context 'When invalid params passed' do
    let(:params) {
      {
        key: feature.namespace_path.path.map(&:to_s).join('_'),
        feature_keys: [feature.key],
        meta: feature.namespace_path.meta.to_h
      }
    }

    it "should return error" do
      subject
      expect(subject).to be_a Dry::Monads::Result::Failure
      expect(subject.failure.errors.to_h).to eq({:path=>["is missing"]})
    end
  end
end