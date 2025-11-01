FactoryBot.define do
  factory :user_credit do
    user { nil }
    total_credits { "9.99" }
    used_credits { "9.99" }
    current_balance { "9.99" }
  end
end
