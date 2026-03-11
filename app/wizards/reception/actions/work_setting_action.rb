module Reception
  module Actions
    class WorkSettingAction < StepAction
      def save!
        if !form.works_in_school? && !form.works_in_childcare?
          current_registration.asssign_attributes(
            kind_of_nursery: nil,
            has_ofsted_urn: nil,
            institution_identifier: nil,
          )
        end

        current_registration.update!(work_setting: form.work_setting,
                                     works_in_school: form.works_in_school?,
                                     works_in_childcare: form.works_in_childcare?)
      end
    end
  end
end
