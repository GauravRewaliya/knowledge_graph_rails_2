FactoryBot.define do
  factory :application_doc_request do
    application_doc { nil }
    title { "MyString" }
    description { "MyText" }
    curl_template { "MyText" }
    swagger_data { "" }
  end
end
