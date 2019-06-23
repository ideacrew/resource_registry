module BenefitSponsors
  module Organizations
    class ProfileCreate
      include BenefitSponsors::Features::Import["benefit_sponsors.feature_repository"]

      def call(attrs)
        features_repository.profile_create(attrs)
      end
    end
  end
end