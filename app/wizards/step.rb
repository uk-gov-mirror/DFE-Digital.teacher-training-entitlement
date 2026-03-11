class Step
  class << self
    def using_form(klass)
      @form_class = klass
    end

    def using_action(klass)
      @action_class = klass
    end
  end

  attr_reader :current_user, :current_registration

  def initialize(current_user:, current_registration:, form_params:)
    @current_user = current_user
    @current_registration = current_registration
    @form_params = form_params
  end

  def valid?
    raise NotImplementedError
  end

  def previous_step
    raise NotImplementedError
  end

  def next_step
    raise NotImplementedError
  end

  def name
    self.class.name.demodulize.underscore.chomp("_step")
  end

  def form
    @form ||= form_class.new(current_registration: @current_registration,
                             **form_params)
  end

  def action
    @action ||= action_class.new(form:,
                                 current_user: @current_user,
                                 current_registration: @current_registration)
  end

  def html_template
    name
  end

private

  def form_params
    return {} if form_class.nil?

    @form_params.permit(form_class.attribute_names)
  end

  def form_class
    self.class.instance_variable_get(:@form_class) || StepForm
  end

  def action_class
    self.class.instance_variable_get(:@action_class) || StepAction
  end
end
