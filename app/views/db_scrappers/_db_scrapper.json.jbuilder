json.extract! db_scrapper, :id, :user_id, :project_id, :url, :meta_data, :source_provider, :sub_type, :response, :fildered_response, :parser_code, :final_response, :knowledge_storage_cypher_code, :created_at, :updated_at
json.url db_scrapper_url(db_scrapper, format: :json)
