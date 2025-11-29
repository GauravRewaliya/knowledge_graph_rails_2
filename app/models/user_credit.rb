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

class UserCredit < ApplicationRecord
  belongs_to :user
  has_many :application_credential_proxy_logs, dependent: :destroy

  validates :total_credits, :used_credits, :current_balance, numericality: { greater_than_or_equal_to: 0 }

  before_validation :calculate_current_balance

  def add_credits(amount)
    update!(
      total_credits: total_credits + amount,
      current_balance: current_balance + amount
    )
  end

  def use_credits(amount)
    return false if current_balance < amount

    update!(
      used_credits: used_credits + amount,
      current_balance: current_balance - amount
    )
  end

  private

  def calculate_current_balance
    self.current_balance = total_credits - used_credits
  end
end
