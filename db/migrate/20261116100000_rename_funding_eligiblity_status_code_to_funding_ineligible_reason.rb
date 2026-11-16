class RenameFundingEligiblityStatusCodeToFundingIneligibleReason < ActiveRecord::Migration[8.1]
  def change
    safety_assured do
      rename_column :applications, :funding_eligiblity_status_code, :funding_ineligible_reason
    end
  end
end
