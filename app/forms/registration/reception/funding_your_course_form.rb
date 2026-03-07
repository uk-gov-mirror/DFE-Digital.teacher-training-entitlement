module Registration
  module Reception
    class FundingYourCourseForm
      include ActiveModel::Model
      include ActiveModel::Attributes

      VALID_FUNDING_OPTIONS = [
        SCHOOL = "school".freeze,
        TRUST = "trust".freeze,
        SELF = "self".freeze,
        ANOTHER_ = "another".freeze,
        EMPLOYER = "employer".freeze,
      ].freeze

      attr_accessor :funding

      validates :funding, presence: true, inclusion: { in: VALID_FUNDING_OPTIONS }

      def options
        VALID_FUNDING_OPTIONS
        [
          build_option_struct(value: "school", link_errors: true),
          (build_option_struct(value: "trust") if works_in_school? && inside_catchment?),
          build_option_struct(value: "self"),
          build_option_struct(value: "another"),
        ].compact.freeze
      end
    end
  end
end
