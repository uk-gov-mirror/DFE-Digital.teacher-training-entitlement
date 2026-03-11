module Reception
  module Actions
    class CourseStartDateAction < StepAction
      def save!
        if form.course_start_date == "yes"
          # TODO: Not sure if the current cohort is the one taking new applications
          # or is it the one currently running? If the latter, then we need to find the next one
          current_registration.update!(course_start: Cohort.application_course_start_date,
                                       cohort: Cohort.current)
          current_user.update!(notify_user_for_future_reg: false)
        else
          current_user.update!(notify_user_for_future_reg: true)
        end
      end
    end
  end
end
