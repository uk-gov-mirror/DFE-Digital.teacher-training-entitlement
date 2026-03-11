class ReceptionRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :lead_provider, optional: true
  belongs_to :course, optional: true
  belongs_to :cohort, optional: true

  VALID_FUNDING_OPTIONS = [
    SCHOOL = "school".freeze,
    TRUST = "trust".freeze,
    SELF = "self".freeze,
    ANOTHER_ = "another".freeze,
    EMPLOYER = "employer".freeze,
  ].freeze

  KIND_OF_NURSERY_PUBLIC_OPTIONS = %w[
    local_authority_maintained_nursery
    preschool_class_as_part_of_school
  ].freeze

  KIND_OF_NURSERY_PRIVATE_OPTIONS = %w[
    childminder
    private_nursery
    another_early_years_setting
  ].freeze

  def valid_funding_options
    if works_in_school? && inside_catchment?
      VALID_FUNDING_OPTIONS - [EMPLOYER]
    else
      VALID_FUNDING_OPTIONS - [TRUST, EMPLOYER]
    end
  end

  def ofsted_route?
    KIND_OF_NURSERY_PRIVATE_OPTIONS.include?(kind_of_nursery)
  end

  def public_nursery?
    KIND_OF_NURSERY_PUBLIC_OPTIONS.include?(kind_of_nursery)
  end

  def kind_of_nursery_private?
    KIND_OF_NURSERY_PRIVATE_OPTIONS.include?(kind_of_nursery)
  end

  def no_institution_selected?
    institution_identifier == "other" || institution_identifier.blank?
  end

  def create_application!
    application = user.applications.create!(
      course:,
      lead_provider:,
      private_childcare_provider: private_childcare_provider_urn.present? && PrivateChildcareProvider.find_by(provider_urn: private_childcare_provider_urn),
      school: school_urn.present? && School.find_by(urn: school_urn),
      ukprn:,
      eligible_for_funding:,
      funding_eligiblity_status_code: funding_eligibility_status_code,
      funding_choice:,
      teacher_catchment:,
      works_in_school:,
      targeted_delivery_funding_eligibility: false,
      primary_establishment:,
      number_of_pupils:,
      tsf_primary_eligibility: false,
      tsf_primary_plus_eligibility: false,
      works_in_childcare:,
      kind_of_nursery:,
      work_setting:,
      lead_mentor: false,
      itt_provider: nil,
      referred_by_return_to_teaching_adviser: false,
      raw_application_data: attributes.except("current_user", "current_user_id"),
      on_submission_trn: user.trn,
      teacher_catchment_country:,
      teacher_catchment_iso_country_code:,
      cohort:,
      lead_provider_approval_status: Application.lead_provider_approval_statuses[:pending],
      review_status: nil,
    )

    SendApplicationSubmissionEmailJob.perform_later(application:)
  end

  def selected_institution
    return nil if institution_identifier.nil?

    @selected_institution ||=
      begin
        klass, identifier = institution_identifier.split("-")
        if klass == "PrivateChildcareProvider" && works_in_childcare?
          PrivateChildcareProvider.find_by(provider_urn: identifier)
        elsif klass == "School" && (works_in_childcare? || works_in_school?)
          School.find_by(urn: identifier)
        elsif klass == "LocalAuthority" && (works_in_childcare? || works_in_school?)
          LocalAuthority.find_by(id: identifier)
        else
          raise StandardError, "Unknown institution type #{klass} or work setting does not match institution type"
        end
      end
  end

  def answers
    array = [

      build_answer("Course start", course_start, :course_start_date),
      build_answer("Course", I18n.t(course.identifier, scope: "course.name"), :choose_your_course),
      build_answer("Provider", lead_provider.name, :choose_your_provider),
      build_answer("Workplace in England", teacher_catchment == "england" ? "Yes" : "No", :teacher_catchment),
      build_answer("Work setting", I18n.t(work_setting, scope: "helpers.label.registration_wizard.work_setting_options"), :work_setting),
    ]

    if public_nursery?
      array << build_answer("Nursery", I18n.t(kind_of_nursery, scope: "helpers.label.registration_wizard.kind_of_nursery_options"), :kind_of_nursery)
    end

    array << build_answer("Workplace", selected_institution&.name_with_address, :choose_school)

    if funding.present?
      array << build_answer("Course funding", I18n.t(funding, scope: "helpers.label.registration_wizard.funding_options"), :funding_your_course)
    end

    array
  end

  def inelegible_for_funding_type
    return :ineligible_setting if kind_of_nursery_private? || works_in_other?

    funding_eligibility_status_code
  end

private

  def works_in_other?
    work_setting == "other"
  end

  def build_answer(key, value, step)
    Struct.new(:key, :value, :step).new(key, value, step)
  end

  def primary_establishment
    selected_institution.is_a?(School) && selected_institution.primary_education_phase?
  end

  def number_of_pupils
    selected_institution.is_a?(School) && selected_institution.number_of_pupils
  end

  def private_childcare_provider_urn
    selected_institution.provider_urn if inside_catchment? && selected_institution.is_a?(PrivateChildcareProvider)
  end

  def school_urn
    selected_institution.urn if inside_catchment? && selected_institution.is_a?(School)
  end

  def ukprn
    if inside_catchment? && (selected_institution.is_a?(LocalAuthority) || selected_institution.is_a?(School))
      selected_institution.ukprn
    end
  end

  def funding_choice
    # It is possible that the applicant had chosen a non-funded path and selected a funding choice
    # before going back a few steps and choosing a funded route. We should clear the funding choice
    # to nil here to reduce confusion
    if eligible_for_funding?
      nil
    else
      funding
    end
  end

  def uk_country
    @uk_country ||= ISO3166::Country.find_country_by_any_name("United Kingdom")
  end

  def in_uk_catchement_area?
    teacher_catchment.in?(Application::UK_CATCHMENT_AREA)
  end

  def teacher_catchment_country
    in_uk_catchement_area? ? uk_country.iso_short_name : nil
  end

  def teacher_catchment_iso_country_code
    return if teacher_catchment_country.blank?
    return uk_country.alpha3 if in_uk_catchement_area?

    if (country = ISO3166::Country.find_country_by_any_name(teacher_catchment_country))
      country.alpha3
    else
      Sentry.capture_message("Could not find the ISO3166 alpha3 code for #{teacher_catchment_country}.", level: :warning)
      nil
    end
  end
end
