module Reception
  module Steps
    class PossibleFundingStep < ::Step
      using_form Forms::PossibleFundingForm
      using_action Actions::PossibleFundingAction

      def valid?
        current_registration.institution_identifier.present?
      end

      def next_step
        :share_provider
      end

      def previous_step
        return :kind_of_nursery if current_registration.kind_of_nursery_private?

        :choose_school
      end
    end
  end
end
