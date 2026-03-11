module Reception
  module Steps
    class TeacherCatchmentStep < ::Step
      using_form Forms::TeacherCatchmentForm
      using_action Actions::TeacherCatchmentAction

      def valid?
        current_registration.lead_provider_id.present?
      end

      def previous_step
        :choose_your_provider
      end

      def next_step
        :work_setting
      end
    end
  end
end
