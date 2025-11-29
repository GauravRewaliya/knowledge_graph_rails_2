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

require 'rails_helper'

RSpec.describe UserCredit, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
