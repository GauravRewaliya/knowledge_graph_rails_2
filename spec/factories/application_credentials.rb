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
