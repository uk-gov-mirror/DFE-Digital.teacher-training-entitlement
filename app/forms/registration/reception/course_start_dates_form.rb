module Registration
  module Reception
    class CourseStartDatesForm
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :course_start_date, :string

      validates_presence_of :course_start_date
    end
  end
end
