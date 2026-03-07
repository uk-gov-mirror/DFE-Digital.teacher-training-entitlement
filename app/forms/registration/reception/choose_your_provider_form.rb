module Registration
  module Reception
    class ChooseYourProviderForm
      include ActiveModel::Model
      include ActiveModel::Attributes

      def initialize(course:, **args)
        @course = course
        super(**args)
      end

      attribute :lead_provider_id, :string

      validates :lead_provider_id, presence: true
      validate :validate_lead_provider_exists, unless: :not_chosen_provider?

      def not_chosen_option
        @not_chosen_option ||= "not_chosen".freeze
      end

      def lead_providers
        @lead_providers ||= LeadProvider.for(course: @course).alphabetical
      end

      def lead_provider
        @lead_provider ||= lead_providers.find_by(id: lead_provider_id)
      end

      def not_chosen_provider?
        lead_provider_id == not_chosen_option
      end

    private

      def validate_lead_provider_exists
        if lead_provider.blank?
          errors.add(:lead_provider_id, :invalid)
        end
      end
    end
  end
end
