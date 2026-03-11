module Reception
  module Actions
    class FundingYourCourseAction < StepAction
      def save!
        current_registration.update!(funding: form.funding)
      end
    end
  end
end
