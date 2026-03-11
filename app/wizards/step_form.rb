class StepForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_reader :current_registration

  def initialize(current_registration:, **params)
    @current_registration = current_registration
    super(**params)
  end
end
