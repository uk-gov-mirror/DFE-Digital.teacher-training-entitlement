module Reception
  module Steps
    class ShareProviderStep < ::Step
      using_form Forms::ShareProviderForm
      using_action Actions::ShareProviderAction

      def valid?
        current_registration.institution_identifier.present?
      end

      def next_step
        :check_answers
      end

      def previous_step
        current_registration.funding.present? ? :funding_your_course : :possible_funding
      end
    end
  end
end
