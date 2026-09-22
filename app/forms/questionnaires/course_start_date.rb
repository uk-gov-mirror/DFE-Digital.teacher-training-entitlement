module Questionnaires
  class CourseStartDate < Base
    class Form < QuestionTypes::RadioButtonGroup
      def type
        "radio_button_group"
      end

      def question_text
        "When do you want to start the course?"
      end
    end

    include ApplicationHelper

    QUESTION_NAME = :course_cohort_ecf_id

    attr_accessor QUESTION_NAME

    validates QUESTION_NAME, presence: true

    def self.permitted_params
      [QUESTION_NAME]
    end

    def questions
      [
        Form.new(
          name: :course_cohort_ecf_id,
          options:,
          style_options: { legend: { size: "m", tag: "h2" } },
        ),
      ]
    end

    def options
      @options ||=
        open_course_cohorts.map { |course_cohort|
          build_option_struct(
            value: course_cohort.ecf_id,
            label: course_cohort.name,
            link_errors: true,
          )
        } + [
          build_option_struct(value: "later", label: "I want to start at a later date"),
        ]
    end

    def requirements_met?
      query_store.current_user
    end

    def next_step
      if course_cohort_ecf_id == "later"
        wizard.current_user.update!(notify_user_for_future_reg: true)
        :cannot_register_yet
      else
        wizard.current_user.update!(notify_user_for_future_reg: false)
        :choose_your_provider
      end
    end

    def previous_step
      :start
    end

    def open_course_cohorts
      @open_course_cohorts ||= query_store.course.open_course_cohorts
    end
  end
end
