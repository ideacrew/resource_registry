module BenefitSponsors
  module Features

    class ApplyFeature

      Repo.register "benefit_sponsors.services.create_profile" do
        Organizations::CreateProfile.new
      end
    end
  end
end