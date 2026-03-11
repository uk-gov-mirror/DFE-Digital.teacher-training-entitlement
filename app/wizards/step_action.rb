class StepAction
  attr_reader :form, :current_user, :current_registration

  def initialize(form:, current_user:, current_registration:)
    @form = form
    @current_user = current_user
    @current_registration = current_registration
  end

  def save!
    raise NotImplementedError
  end
end
