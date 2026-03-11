module Reception
  module Steps
    class FundingYourCourseStep < ::Step
      using_form Forms::FundingYourCourseForm
      using_action Actions::FundingYourCourseAction

      def valid?
        true
      end

      def next_step
        :share_provider
      end

      def previous_step
        :ineligible_for_funding
      end
    end
  end
end
