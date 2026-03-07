module Registration
  module Reception
    class PossibleFundingForm
      include ActiveModel::Model
      include ActiveModel::Attributes
      include Helpers::Institution

      attribute :institution_identifier, :string
      attribute :institution_name, :string

      validates :institution_identifier, format: { with: /\ASchool-\d{6,7}\z|\ALocalAuthority-\d+\z/, unless: -> { institution_identifier.blank? || institution_identifier == "other" } }
      validates :institution_name, length: { maximum: 64 }

      def question
        QuestionTypes::AutoCompleteInstitution.new(
          name: :institution_identifier,
          locale_name: :choose_school,
          picker: :school,
          options: possible_institutions,
          display_no_javascript_fallback_form: search_term_entered_in_no_js_fallback_form?,
          search_question: QuestionTypes::TextField.new(
            name: :institution_name,
            locale_name: :choose_school_search,
          ),
          default_value: selected_institution_display_value,
        )
      end

    private

      def selected_institution
        return nil if institution_identifier.blank?

        @selected_institution ||= institution(source: institution_identifier)
      end

      def selected_institution_display_value
        selected_institution&.name_with_address
      end

      def possible_institutions
        return [] if institution_name.blank?

        @possible_institutions ||= begin
          schools = School
            .search_by_name(institution_name)
            .open
            .limit(10)

          local_authorities = LocalAuthority
            .search_by_name(institution_name)
            .limit(10)

          schools + local_authorities
        end
      end

      def search_term_entered_in_no_js_fallback_form?
        false # TODO: !
        # This combination of fields is only used in the no-js fallback form
        # institution_name will be set from the search term being entered into the search
        # field that is only visible when JS is disabled.
        #
        # TODO ....
        # wizard.store["institution_name"].present?
      end
    end
  end
end
