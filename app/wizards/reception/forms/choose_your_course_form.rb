module Reception
  module Forms
    class ChooseYourCourseForm < StepForm
      attribute :course_identifier, :string

      validates_presence_of :course_identifier

      # TODO: We only have one reception course at the moment
      def course
        @course ||= Course.displayable.first
      end
    end
  end
end
