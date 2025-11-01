class CreateApplicationDocRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :application_doc_requests do |t|
      t.references :application_doc, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.text :curl_template
      t.jsonb :swagger_data

      t.timestamps
    end
  end
end
