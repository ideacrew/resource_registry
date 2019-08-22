# frozen_string_literal: true

module BenefitSponsors
  module Features
    # class DynamicSetting

    #   def initialize(tenant:, service_key:)
    #     @tenant = tenant
    #   end

    #   FeatureRepository.register "benefit_sponsors.features_repository" do
    #     BenefitSponsors::Features::FeatureRepository
    #     # BenefitSponsors::Features::FeatureRepository.new
    #   end

    # Inline in code, the call will look soemthing like:
    # new_profile = DynamicSetting(tenant: Current.tenant, service: :create_profile)

    # Hardcoded for initial testing
    # For any system behavior, this section does a lookup for the passed tenant's
    # configuration settings to set the proper dependency injection to invoke
    # (see commented example below)

    # FeatureRepository.register "benefit_sponsors.services.create_profile" do
    #   Organizations::CreateProfile.new
    # end

    # Example
    # FeatureRepository.register "benefit_sponsors.services.create_profile" do
    #   if ResourceRegistry::Repository["#{tenant}.benefit_sponsors.profile_type"].value == "exempt"
    #     Organizations::CreateExemptProfile.new
    #   else
    #     Organizations::CreateProfile.new
    #   end
    # end

    # end
  end
end