module Reception
  module Steps
    class ChooseSchoolStep < ::Step
      using_form Forms::ChooseSchoolForm
      using_action Actions::ChooseSchoolAction

      def valid?
        current_registration.work_setting.present?
      end

      def previous_step
        if current_registration.works_in_childcare?
          :kind_of_nursery
        else
          :work_setting
        end
      end

      def next_step
        return :choose_school if current_registration.no_institution_selected?
        return :ineligible_for_funding unless funding_eligibility_service.eligible_for_funding?

        :possible_funding
      end

    private

      def funding_eligibility_service
        @funding_eligibility_service ||= FundingEligibility.new(
          course: current_registration.course,
          institution: current_registration.selected_institution,
          inside_catchment: current_registration.inside_catchment?,
          trn: current_user.trn,
          get_an_identity_id: current_registration.get_an_identity_id,
          work_setting: current_registration.work_setting,
          kind_of_nursery: current_registration.kind_of_nursery,
        )
      end
    end
  end
end
