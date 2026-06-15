# frozen_string_literal: true

module Admin
  module Applications
    module APITests
      class ResetToPendingController < APITestsController
        def create
          if Rails.env.production? || !current_admin.super_admin?
            redirect_to admin_applications_api_tests_path(@application),
                        flash: { alert: "You're not allowed to do that" }
            return
          end

          ActiveRecord::Base.transaction do
            @application.application_events.destroy_all
            @application.declarations.destroy_all
            @application.admin_user = current_admin
            @application.update!(status: Application::PENDING, funded_place: nil)
          end

          redirect_to admin_applications_api_tests_path(@application),
                      flash: { success: "Application reset to pending." }
        end
      end
    end
  end
end
