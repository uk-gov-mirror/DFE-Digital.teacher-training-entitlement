module Reception
  module Steps
    class KindOfNurseryStep < ::Step
      using_form Forms::KindOfNurseryForm
      using_action Actions::KindOfNurseryAction

      def valid?
        current_registration.work_setting.present?
      end

      def next_step
        return :choose_school if current_registration.public_nursery?

        :ineligible_for_funding
      end

      def previous_step
        :work_setting
      end
    end
  end
end
