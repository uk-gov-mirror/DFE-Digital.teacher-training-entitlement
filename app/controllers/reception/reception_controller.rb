module Reception
  class ReceptionController < ::PublicPagesController
    helper_method :current_registration

  protected

    def current_registration
      # TODO: Probably need the one for the course/cohort
      # rather than just the last one, but this is good enough for now
      @current_registration ||= current_user.reception_registrations.last ||
        ReceptionRegistration.new(user: current_user)
    end
  end
end
