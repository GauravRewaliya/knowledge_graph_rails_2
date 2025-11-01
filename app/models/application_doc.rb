class ApplicationDoc < ApplicationRecord
  store :docs, accessors: [ :openapi_version, :info, :external_docs ], coder: JSON
  store :auth_fields, accessors: [ :api_key_param, :engine_param, :query_param ], coder: JSON

  has_many :api_endpoints, dependent: :destroy
  has_many :application_credentials, dependent: :destroy
  has_many :application_doc_requests, dependent: :destroy
end
