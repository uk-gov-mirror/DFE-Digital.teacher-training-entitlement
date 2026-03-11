module Reception
  module Actions
    class ChooseSchoolAction < StepAction
      def save!
        current_registration.assign_attributes(institution_identifier: form.institution_identifier,
                                               institution_name: form.institution_name)
        current_registration.update!(
          funding_eligibility_status_code: funding_eligibility_service.funding_eligiblity_status_code,
          eligible_for_funding: funding_eligibility_service.eligible_for_funding?,
        )
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
