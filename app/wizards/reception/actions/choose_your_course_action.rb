module Reception
  module Actions
    class ChooseYourCourseAction < StepAction
      def save!
        course = Course.find_by(identifier: form.course_identifier)
        current_registration.update!(course:)
      end
    end
  end
end
