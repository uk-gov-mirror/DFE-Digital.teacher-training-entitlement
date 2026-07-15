class AddSearchIndexes < ActiveRecord::Migration[8.1]
  disable_ddl_transaction!

  def change
    add_index :institutions,
      "to_tsvector('english', coalesce(name, '') || ' ' || coalesce(town, '') || ' ' || coalesce(postcode, '') || ' ' || coalesce(postcode_without_spaces, ''))",
      using: :gin,
      name: "index_institutions_on_searchable_text",
      algorithm: :concurrently

    add_index :schools,
      :establishment_status_code,
      algorithm: :concurrently
  end
end
