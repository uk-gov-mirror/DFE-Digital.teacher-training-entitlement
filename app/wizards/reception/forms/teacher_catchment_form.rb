module Reception
  module Forms
    class TeacherCatchmentForm < StepForm
      attribute :teacher_catchment, :string

      validates_presence_of :teacher_catchment
    end
  end
end
