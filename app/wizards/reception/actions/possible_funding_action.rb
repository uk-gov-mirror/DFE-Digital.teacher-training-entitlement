module Reception
  module Actions
    class PossibleFundingAction < StepAction
      def save!
        current_registration.update!(funding: nil)
      end
    end
  end
end
