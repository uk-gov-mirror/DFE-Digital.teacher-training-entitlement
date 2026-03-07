module Reception
  class ChooseSchoolController < ReceptionController
    before_action :set_form

    def create
      if @form.invalid?
        render :index, status: :unprocessable_entity and return
      end

      current_registration.update!(institution_identifier: @form.institution_identifier,
                                   institution_name: @form.institution_name,
                                   funding_eligiblity_status_code: funding_eligibility_service.funding_eligiblity_status_code)

      return redirect_to reception_choose_school_index_path if current_registration.no_institution_selected?
      return redirect_to reception_ineligible_for_funding_index_path unless funding_eligibility_service.eligible_for_funding?

      redirect_to reception_possible_funding_index_path
    end

  private

    def funding_eligibility_service
      @funding_eligibility_service ||= FundingEligibility.new(
        course: current_registration.course,
        institution: current_registration.selected_institution,
        inside_catchment: current_registration.inside_catchment?,
        trn: current_registration.trn,
        get_an_identity_id: current_registration.get_an_identity_id,
        work_setting: current_registration.work_setting,
        kind_of_nursery: current_registration.kind_of_nursery,
      )
    end

    def set_form
      @form = Registration::Reception::ChooseSchoolForm.new(form_params)
    end

    def form_params
      params
        .fetch(:form, {})
        .permit(*Registration::Reception::ChooseSchoolForm.attribute_names)
    end
  end
end
