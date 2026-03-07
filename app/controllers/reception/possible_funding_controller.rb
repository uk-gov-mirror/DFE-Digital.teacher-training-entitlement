module Reception
  class PossibleFundingController < ReceptionController
    before_action :set_form

    def create
      if @form.invalid?
        render :index, status: :unprocessable_entity and return
      end

      current_registration.update!(institution_identifier: @form.institution_identifier,
                                   institution_name: @form.institution_name)
      return redirect_to reception_choose_school_index_path if no_institution_selected?
      return redirect_to reception_ineligible_for_funding_index_path unless eligible_for_funding?

      redirect_to reception_possible_funding_index_path
    end

  private

    def no_institution_selected?
      @form.institution_identifier == "other" || @form.institution_identifier.blank?
    end

    def eligible_for_funding?
      # TODO: Implement this properly
      return false if 1.positive?

      selected_institution.in_england? &&
        selected_institution.eligible_establishment? &&
        !funding_eligibility.previously_funded? &&
        funding_eligibility.funded?
    end

    def funding_eligibility
      @funding_eligibility ||= FundingEligibility.new(
        course: wizard.query_store.course,
        institution: selected_institution,
        inside_catchment: wizard.query_store.inside_catchment?,
        trn: wizard.query_store.trn,
        get_an_identity_id: wizard.query_store.get_an_identity_id,
        query_store: wizard.query_store,
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
