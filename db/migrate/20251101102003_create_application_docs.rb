class CreateApplicationDocs < ActiveRecord::Migration[8.0]
  def change
    create_table :application_docs do |t|
      t.string :title
      t.text :description
      t.string :base_url
      t.text :tags
      t.boolean :is_active
      t.jsonb :docs
      t.jsonb :auth_fields

      t.timestamps
    end
  end
end
