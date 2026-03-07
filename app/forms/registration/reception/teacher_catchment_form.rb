module Registration
  module Reception
    class TeacherCatchmentForm
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :teacher_catchment, :string

      validates_presence_of :teacher_catchment
    end
  end
end
