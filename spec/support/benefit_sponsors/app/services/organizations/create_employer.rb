module BenefitSponsors
  module Organizations
    class CreateEmployer
      attr_reader :validate_employer, :persist_employer

      include Features::Import["benefit_sponsors.features_repository"]


      def initialize(validate_employer, persist_employer)
        @validate_employer = validate_employer
        @persist_employer  = persist_employer
      end

      def call(params)
        result = validate_employer.call(params)

        if result.success?
          persist_employer.call(params)
        end

        # puts features_repository.inspect
      end
      
    end
  end
end