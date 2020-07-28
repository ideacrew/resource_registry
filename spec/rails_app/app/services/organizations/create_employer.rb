# frozen_string_literal: true

module BenefitSponsors
  module Organizations
    class CreateEmployer
      attr_reader :validate_employer, :persist_employer

      # include Features::Import["benefit_sponsors.features_repository"]


      def initialize(validate_employer, persist_employer)
        @validate_employer = validate_employer
        @persist_employer  = persist_employer
      end

      def call(params)
        result = validate_employer.call(params)

        persist_employer.call(params) if result.success?
      end

    end
  end
end
