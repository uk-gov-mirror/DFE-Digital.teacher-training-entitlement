# frozen_string_literal: true

module CourseCohorts
  class Create
    include ActiveModel::Model

    attr_reader :cohort,
                :course_id,
                :course_cohort,
                :training_starts_at,
                :training_ends_at,
                :lead_provider_params

    validates :cohort, presence: true
    validates :course_id, presence: true
    validate :course_present
    validates :training_starts_at, presence: true
    validate :at_least_one_lead_provider_selected

    def initialize(cohort:, course_cohort_params:, lead_provider_params:)
      @cohort = cohort
      @course_id = course_cohort_params[:course_id]
      @training_starts_at = course_cohort_params[:training_starts_at]
      @training_ends_at = course_cohort_params[:training_ends_at]
      @lead_provider_params = lead_provider_params
    end

    def call
      return if invalid?

      term_identifier = CourseCohort.school_term(training_starts_at)
      academic_year = cohort.start_year

      CourseCohort.transaction do
        @course_cohort = cohort.course_cohorts.create!(
          course:,
          academic_year:,
          term_identifier:,
        )

        course_cohort.milestones.started.create!(acceptance_window_start_date: training_starts_at)
        if training_ends_at
          course_cohort.milestones.completed.create!(
            acceptance_window_start_date: training_ends_at - 2.months,
            acceptance_window_end_date: training_ends_at,
          )
        end

        selected_providers.each do |lead_provider_id, attrs|
          lead_provider = LeadProvider.find(lead_provider_id)

          course_cohort.course_cohort_providers.create!(
            lead_provider:,
            teacher_funding: attrs["teacher_funding"].presence,
            recruitment_target: attrs["recruitment_target"].presence,
          )

          lead_provider.delivery_partners.each do |delivery_partner|
            course_cohort.delivery_partnerships.create!(
              lead_provider:,
              delivery_partner:,
            )
          end
        end
      end
    end

    def course
      @course ||= Course.find_by(id: course_id)
    end

  private

    def selected_providers
      lead_provider_params&.select { |_, attrs| attrs["id"].present? && attrs["id"] != "0" }
    end

    def course_present
      errors.add(:missing_course) unless course
    end

    def at_least_one_lead_provider_selected
      if selected_providers.blank?
        errors.add(:lead_providers, "Select at least one lead provider")
      end
    end
  end
end
