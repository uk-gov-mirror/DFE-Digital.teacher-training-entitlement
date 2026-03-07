module Reception
  class TeacherCatchmentController < ReceptionController
    before_action :set_form

    def create
      if @form.invalid?
        render :index, status: :unprocessable_entity and return
      end

      current_registration.update!(teacher_catchment: @form.teacher_catchment,
                                   inside_catchment: @form.teacher_catchment == "england")

      redirect_to reception_work_setting_index_path
    end

  private

    def set_form
      @form = Registration::Reception::TeacherCatchmentForm.new(form_params)
    end

    def form_params
      params
        .fetch(:form, {})
        .permit(*Registration::Reception::TeacherCatchmentForm.attribute_names)
    end
  end
end
