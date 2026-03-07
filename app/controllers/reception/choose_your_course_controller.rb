module Reception
  class ChooseYourCourseController < ReceptionController
    before_action :set_form

    def create
      if @form.invalid?
        render :index, status: :unprocessable_entity and return
      end

      current_registration.update!(course: Course.find_by(identifier: @form.course_identifier))

      redirect_to reception_choose_your_provider_index_path
    end

  private

    def set_form
      @form = Registration::Reception::ChooseYourCourseForm.new(form_params)
    end

    def form_params
      params
        .fetch(:form, { course_identifier: Course.displayable.first.identifier })
        .permit(*Registration::Reception::ChooseYourCourseForm.attribute_names)
    end
  end
end
