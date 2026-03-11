module Reception
  module Actions
    class KindOfNurseryAction < StepAction
      def save!
        current_registration.institution_identifier = nil unless current_registration.public_nursery?
        current_registration.update!(kind_of_nursery: form.kind_of_nursery)
      end
    end
  end
end
