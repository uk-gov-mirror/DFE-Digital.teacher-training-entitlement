module Reception
  module Steps
    class ChooseYourProviderStep < ::Step
      using_form Forms::ChooseYourProviderForm
      using_action Actions::ChooseYourProviderAction

      def valid?
        current_registration.course_id.present?
      end

      def previous_step
        :choose_your_course
      end

      def next_step
        if form.not_chosen_provider?
          :choose_a_tte_and_provider
        else
          :teacher_catchment
        end
      end
    end
  end
end
