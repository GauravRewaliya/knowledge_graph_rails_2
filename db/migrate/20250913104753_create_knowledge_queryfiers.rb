class CreateKnowledgeQueryfiers < ActiveRecord::Migration[8.0]
  def change
    create_table :knowledge_queryfiers do |t|
      t.references :user, null: true, foreign_key: true
      t.references :project, null: false, foreign_key: true
      t.text :cypher_dynamic_query
      t.jsonb :meta_data_swagger_docs
      t.string :tags
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
