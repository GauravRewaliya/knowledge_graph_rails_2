# == Schema Information
#
# Table name: application_credentials
#
#  id                 :integer          not null, primary key
#  application_doc_id :integer          not null
#  title              :string
#  description        :text
#  credential_type    :string
#  rate_limits        :jsonb
#  settings           :jsonb
#  auth_data          :jsonb
#  is_active          :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_application_credentials_on_application_doc_id  (application_doc_id)
#

FactoryBot.define do
  factory :application_credential do
    application_doc { nil }
    title { "MyString" }
    description { "MyText" }
    credential_type { "MyString" }
    rate_limits { "" }
    settings { "" }
    auth_data { "" }
    is_active { false }
  end
end
