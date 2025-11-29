json.extract! api_log, :id, :method, :target_url, :request, :response, :created_at, :updated_at
json.url api_log_url(api_log, format: :json)
