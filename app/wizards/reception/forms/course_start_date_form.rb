module Reception
  module Forms
    class CourseStartDateForm < StepForm
      attribute :course_start_date, :string

      validates_presence_of :course_start_date
    end
  end
end
