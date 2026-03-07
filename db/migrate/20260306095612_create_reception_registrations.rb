class CreateReceptionRegistrations < ActiveRecord::Migration[8.1]
  def change
    create_table :reception_registrations do |t|
      t.boolean :works_in_school
      t.boolean :works_in_childcare
      t.string :teacher_catchment
      t.boolean :inside_catchment
      t.string :institution_identifier
      t.string :institution_name
      t.string :funding_eligiblity_status_code
      t.string :course_start
      t.string :get_an_identity_id
      t.string :trn
      t.string :kind_of_nursery
      t.string :work_setting
      t.references :user, null: false, foreign_key: true
      t.references :lead_provider, null: true, foreign_key: true
      t.references :cohort, null: true, foreign_key: true
      t.references :course, null: true, foreign_key: true
      t.timestamps
    end
  end
end
