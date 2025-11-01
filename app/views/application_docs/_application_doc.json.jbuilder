json.extract! application_doc, :id, :title, :description, :base_url, :tags, :is_active, :docs, :auth_fields, :created_at, :updated_at
json.url application_doc_url(application_doc, format: :json)
