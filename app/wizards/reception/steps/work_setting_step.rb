module Reception
  module Steps
    class WorkSettingStep < ::Step
      using_form Forms::WorkSettingForm
      using_action Actions::WorkSettingAction

      def valid?
        current_registration.teacher_catchment.present?
      end

      def previous_step
        :teacher_catchment
      end

      def next_step
        return :ineligible_for_funding unless current_registration.inside_catchment?

        return :choose_school if form.works_in_school?
        return :kind_of_nursery if form.works_in_childcare?

        :ineligible_for_funding
      end
    end
  end
end
