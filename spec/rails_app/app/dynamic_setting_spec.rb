# frozen_string_literal: true

require "./spec/spec_helper"
require 'dry/container/stub'

RSpec.describe 'AutoInject' do
  describe 'benefit_sponsors' do
    describe 'features' do
      let(:tenant_name)             { :dchbx }
      let(:feature_repository)      { BenefitSponsors::Features::FeatureRepository }
      let(:create_profile_service)  { feature_repository["benefit_sponsors.services.create_profile"] }

      # it "should do something" do
      #   expect(create_profile_service.call).to be_nil
      # end

    end
  end
end
