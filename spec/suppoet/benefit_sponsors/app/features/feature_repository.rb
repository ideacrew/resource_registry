require "dry-auto_inject"

module BenefitSponsors
  module Features
    Repo =  ResourceRegistry::Repository.new
    Import = Dry::AutoInject(Repo)
    class FeatureRepository
      Repo.register "benefit_sponsors.feature_repository" do
        BenefitSponsors::Features::FeaturesRepository.new
      end

      Repo.register "services.create_profile" do
        Organizations::CreateProfile.new
      end
    end
  end
end