module Reception
  module Actions
    class ChooseYourProviderAction < StepAction
      def save!
        current_registration.update!(lead_provider_id: form.lead_provider_id)
      end
    end
  end
end
