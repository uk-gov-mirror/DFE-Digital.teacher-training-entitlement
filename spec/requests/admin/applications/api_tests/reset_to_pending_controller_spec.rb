# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Applications::APITests::ResetToPendingController, type: :request do
  include Helpers::NPQSeparationAdminLogin

  subject(:make_request) { post admin_applications_api_tests_reset_to_pending_path(application) }

  let(:lead_provider) { create(:lead_provider) }
  let(:application) { create(:application, :started, :with_funded_place, lead_provider:) }

  before { sign_in_as_admin(super_admin: true) }

  describe "#create" do
    it "resets the application to pending and destroys associated application events and declarations" do
      application_event = create(:application_event, application:)
      state_change = create(:state_change, :started, application:)
      declaration = create(:declaration, :started, application:)

      expect { make_request }
        .to change { application.reload.status }.from(Application::STARTED).to(Application::PENDING)
        .and change { application.reload.funded_place }.from(true).to(nil)
        .and change { ApplicationEvent.exists?(application_event.id) }.from(true).to(false)
        .and change { ApplicationEvent.exists?(state_change.id) }.from(true).to(false)
        .and change { Declaration.exists?(declaration.id) }.from(true).to(false)

      expect(response).to redirect_to(admin_applications_api_tests_path(application))
    end

    it "uses destroy on the application events and declarations associations" do
      application.declarations.destroy_all
      create(:application_event, application:)
      create(:declaration, :started, application:)

      expect_any_instance_of(ApplicationEvent).to receive(:destroy).at_least(:once).and_call_original
      expect_any_instance_of(Declaration).to receive(:destroy).at_least(:once).and_call_original

      make_request
    end

    context "when running in production" do
      before { allow(Rails.env).to receive(:production?).and_return(true) }

      it "is not available" do
        make_request

        expect(response).to have_http_status(302)
        expect(flash[:alert]).to eq("You're not allowed to do that")
      end
    end
  end
end
