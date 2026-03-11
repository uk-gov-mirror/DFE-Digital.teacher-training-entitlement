module Reception
  module Steps
    class CheckAnswersStep < ::Step
      using_form Forms::CheckAnswersForm
      using_action Actions::CheckAnswersAction

      def valid?
        current_registration.institution_identifier.present?
      end

      def previous_step
        :share_provider
      end

      def next_step
        :finish
      end
    end
  end
end
