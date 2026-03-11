module Reception
  module Forms
    class FundingYourCourseForm < StepForm
      attribute :funding

      validates_presence_of :funding
      validate :validate_funding

      def options
        current_registration.valid_funding_options
      end

    private

      def validate_funding
        if funding.present? && !current_registration.valid_funding_options.include?(funding)
          errors.add(:funding, :inclusion)
        end
      end
    end
  end
end
