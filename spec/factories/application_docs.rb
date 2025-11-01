FactoryBot.define do
  factory :application_doc do
    title { "MyString" }
    description { "MyText" }
    base_url { "MyString" }
    tags { "MyText" }
    is_active { false }
    docs { "" }
    auth_fields { "" }
  end
end
