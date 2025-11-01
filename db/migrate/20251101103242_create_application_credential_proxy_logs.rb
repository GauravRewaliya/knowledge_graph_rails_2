class CreateApplicationCredentialProxyLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :application_credential_proxy_logs do |t|
      t.references :application_doc, null: false, foreign_key: true
      t.references :application_credential, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.jsonb :request_data
      t.jsonb :response_data
      t.datetime :requested_at
      t.datetime :finished_at
      t.decimal :credits_used
      t.integer :duration_ms

      t.timestamps
    end
  end
end
