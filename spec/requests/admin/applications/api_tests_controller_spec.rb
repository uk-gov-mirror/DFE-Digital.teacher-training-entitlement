# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::Applications::APITestsController, type: :request do
  include Helpers::NPQSeparationAdminLogin

  subject { response }

  let(:application) { create(:application, :accepted) }

  before { sign_in_as_admin(super_admin: true) }

  describe "#index" do
    before { get admin_applications_api_tests_path(application) }

    it { is_expected.to have_http_status :success }

    it "shows the reset to pending button" do
      expect(response.body).to include("Reset to pending")
      expect(response.body).to include(admin_applications_api_tests_reset_to_pending_path(application))
    end
  end
end
