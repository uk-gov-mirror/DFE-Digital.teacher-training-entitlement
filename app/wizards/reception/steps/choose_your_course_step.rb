module Reception
  module Steps
    class ChooseYourCourseStep < ::Step
      using_form Forms::ChooseYourCourseForm
      using_action Actions::ChooseYourCourseAction

      def valid?
        current_registration&.cohort.present?
      end

      def previous_step
        :course_start_date
      end

      def next_step
        :choose_your_provider
      end
    end
  end
end
