json.extract! application_doc_request, :id, :application_doc_id, :title, :description, :curl_template, :swagger_data, :created_at, :updated_at
json.url application_doc_request_url(application_doc_request, format: :json)
