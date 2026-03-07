module Reception
  class CourseStartDatesController < ReceptionController
    before_action :set_form

    def create
      if @form.invalid?
        render :index, status: :unprocessable_entity and return
      end

      # TODO: Not sure if the current cohort is the one taking new applications
      # or is it the one currently running? If the latter, then we need to find the next one
      current_registration.update!(course_start: Cohort.application_course_start_date,
                                   cohort: Cohort.current)

      if @form.course_start_date == "yes"
        current_user.update!(notify_user_for_future_reg: false)
        redirect_to reception_choose_your_course_index_path
      else
        current_user.update!(notify_user_for_future_reg: true)
        redirect_to reception_cannot_register_yet_index_path
      end
    end

  private

    def set_form
      @form = Registration::Reception::CourseStartDatesForm.new(form_params)
    end

    def form_params
      params
        .fetch(:form, {})
        .permit(*Registration::Reception::CourseStartDatesForm.attribute_names)
    end
  end
end
