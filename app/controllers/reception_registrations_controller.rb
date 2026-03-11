class ReceptionRegistrationsController < ::PublicPagesController
  before_action :set_step

  def show
    redirect_to reception_registration_path(@step.name) and return if @step.name.to_s != params[:step]

    render @step.html_template
  end

  def update
    if @form.invalid?
      render @step.html_template, status: :unprocessable_entity and return
    end

    @action.save!
    redirect_to reception_registration_path(@step.next_step)
  end

  helper_method :current_registration

private

  def set_step
    flow = Reception::Flow.new(params[:step])

    @step = flow.build_step(current_user:,
                            current_registration:,
                            form_params:)
    @form = @step.form
    @action = @step.action
  end

  def current_registration
    # TODO: Probably need the one for the course/cohort
    # rather than just the last one, but this is good enough for now
    @current_registration ||= current_user.reception_registrations.last ||
      ReceptionRegistration.new(user: current_user)
  end

  def form_params
    params.fetch(:form, {})
  end
end
