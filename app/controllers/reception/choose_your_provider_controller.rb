module Reception
  class ChooseYourProviderController < ReceptionController
    before_action :set_form

    def create
      if @form.invalid?
        render :index, status: :unprocessable_entity and return
      end

      current_registration.update!(lead_provider_id: @form.lead_provider_id)

      if @form.not_chosen_provider?
        redirect_to reception_choose_a_tte_and_provider_index_path
      else
        redirect_to reception_teacher_catchment_index_path
      end
    end

  private

    def set_form
      @form = Registration::Reception::ChooseYourProviderForm.new(
        course: current_registration.course, **form_params,
      )
    end

    def form_params
      params
        .fetch(:form, {})
        .permit(*Registration::Reception::ChooseYourProviderForm.attribute_names)
    end
  end
end
