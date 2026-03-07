class ReceptionRegistration < ApplicationRecord
  belongs_to :user
  belongs_to :lead_provider, optional: true
  belongs_to :course, optional: true
  belongs_to :cohort, optional: true

  def no_institution_selected?
    institution_identifier == "other" || institution_identifier.blank?
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
end
