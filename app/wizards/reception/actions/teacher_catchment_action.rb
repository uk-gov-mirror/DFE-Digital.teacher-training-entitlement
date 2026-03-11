module Reception
  module Actions
    class TeacherCatchmentAction < StepAction
      def save!
        current_registration.update!(teacher_catchment: form.teacher_catchment,
                                     inside_catchment: form.teacher_catchment == "england")
      end
    end
  end
end
