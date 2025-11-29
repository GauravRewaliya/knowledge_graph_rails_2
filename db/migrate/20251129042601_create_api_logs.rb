class CreateApiLogs < ActiveRecord::Migration[8.0]
  def change
    create_table :api_logs do |t|
      t.string :method
      t.string :target_url
      t.jsonb :request
      t.jsonb :response

      t.timestamps
    end
  end
end
