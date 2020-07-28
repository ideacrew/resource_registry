# frozen_string_literal: true

module BenefitSponsors
  module Organizations
    class CreateExemptProfile
      # include Features::Import["benefit_sponsors.features_repository"]

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
