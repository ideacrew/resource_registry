module BenefitSponsors
  module Organizations
    class CreateProfile
      include Features::Import["benefit_sponsors.features_repository"]

      # def call(attrs)
      #   features_repository.create(attrs)
      # end

      def call
        puts features_repository.inspect
        # features_repository.profile_create(attrs)
      end
    end
  end
end