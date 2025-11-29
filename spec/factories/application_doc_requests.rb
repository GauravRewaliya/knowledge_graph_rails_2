# == Schema Information
#
# Table name: application_doc_requests
#
#  id                 :integer          not null, primary key
#  application_doc_id :integer          not null
#  title              :string
#  description        :text
#  curl_template      :text
#  swagger_data       :jsonb
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_application_doc_requests_on_application_doc_id  (application_doc_id)
#

FactoryBot.define do
  factory :application_doc_request do
    application_doc { nil }
    title { "MyString" }
    description { "MyText" }
    curl_template { "MyText" }
    swagger_data { "" }
  end
end
