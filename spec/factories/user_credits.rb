# == Schema Information
#
# Table name: user_credits
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  total_credits   :decimal(, )
#  used_credits    :decimal(, )
#  current_balance :decimal(, )
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_user_credits_on_user_id  (user_id)
#

FactoryBot.define do
  factory :user_credit do
    user { nil }
    total_credits { "9.99" }
    used_credits { "9.99" }
    current_balance { "9.99" }
  end
end
