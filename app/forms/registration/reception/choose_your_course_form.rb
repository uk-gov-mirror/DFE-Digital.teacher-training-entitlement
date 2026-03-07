module Registration
  module Reception
    class ChooseYourCourseForm
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :course_identifier, :string

      validates_presence_of :course_identifier

      def course
        @course ||= Course.find_by(identifier: course_identifier)
      end
    end
  end
end
