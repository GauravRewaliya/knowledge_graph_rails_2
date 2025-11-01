json.extract! application_credential, :id, :application_doc_id, :title, :description, :credential_type, :rate_limits, :settings, :auth_data, :is_active, :created_at, :updated_at
json.url application_credential_url(application_credential, format: :json)
