module Reception
  module Actions
    class CheckAnswersAction < StepAction
      def save!
        current_registration.create_application!

        # wizard.store["submitted"] = true
        # wizard.session["clear_tra_login"] = true
      end
    end
  end
end
