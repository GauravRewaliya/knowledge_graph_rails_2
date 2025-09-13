class CreateDbScrappers < ActiveRecord::Migration[8.0]
  def change
    create_table :db_scrappers do |t|
      t.references :user, null: false, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.string :url
      t.jsonb :meta_data
      t.string :source_provider
      t.string :sub_type
      t.jsonb :response
      t.jsonb :fildered_response
      t.text :parser_code
      t.string :final_response
      t.text :knowledge_storage_cypher_code

      t.timestamps
    end
  end
end
