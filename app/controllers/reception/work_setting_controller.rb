module Reception
  class WorkSettingController < ReceptionController
    before_action :set_form

    def create
      if @form.invalid?
        render :index, status: :unprocessable_entity and return
      end

      current_registration.update!(works_in_school: @form.works_in_school?,
                                   works_in_childcare: @form.works_in_childcare?)
      # TODO: ... do we need to do this?
      # %w[kind_of_nursery has_ofsted_urn institution_identifier].each { |field| wizard.store.delete(field) }

      return redirect_to reception_ineligible_for_funding_index_path unless current_registration.inside_catchment?
      return redirect_to reception_choose_school_index_path if @form.works_in_school?
      return redirect_to reception_kind_of_nursery_index_path if @form.works_in_childcare?

      redirect_to reception_ineligible_for_funding_index_path
    end

  private

    def set_form
      @form = Registration::Reception::WorkSettingForm.new(form_params)
    end

    def form_params
      params
        .fetch(:form, {})
        .permit(*Registration::Reception::WorkSettingForm.attribute_names)
    end
  end
end
