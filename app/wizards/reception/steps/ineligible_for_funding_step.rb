module Reception
  module Steps
    class IneligibleForFundingStep < ::Step
      using_form Forms::IneligibleForFundingForm
      using_action Actions::IneligibleForFundingAction

      def valid?
        current_registration.work_setting.present?
      end

      def previous_step
        :start
      end

      def next_step
        :funding_your_course
      end
    end
  end
end
