class CreateApplicationCredentials < ActiveRecord::Migration[8.0]
  def change
    create_table :application_credentials do |t|
      t.references :application_doc, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :credential_type
      t.jsonb :rate_limits
      t.jsonb :settings
      t.jsonb :auth_data
      t.boolean :is_active

      t.timestamps
    end
  end
end
