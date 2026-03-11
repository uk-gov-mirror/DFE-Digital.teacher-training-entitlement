module Reception
  module Steps
    class CourseStartDateStep < ::Step
      using_form Forms::CourseStartDateForm
      using_action Actions::CourseStartDateAction

      def valid?
        current_registration.present?
      end

      def previous_step
        :start
      end

      def next_step
        if form.course_start_date == "yes"
          :choose_your_course
        else
          :cannot_register_yet
        end
      end
    end
  end
end
