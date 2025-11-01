require 'rails_helper'

RSpec.describe "user_credits/edit", type: :view do
  let(:user_credit) {
    UserCredit.create!(
      user: nil,
      total_credits: "9.99",
      used_credits: "9.99",
      current_balance: "9.99"
    )
  }

  before(:each) do
    assign(:user_credit, user_credit)
  end

  it "renders the edit user_credit form" do
    render

    assert_select "form[action=?][method=?]", user_credit_path(user_credit), "post" do

      assert_select "input[name=?]", "user_credit[user_id]"

      assert_select "input[name=?]", "user_credit[total_credits]"

      assert_select "input[name=?]", "user_credit[used_credits]"

      assert_select "input[name=?]", "user_credit[current_balance]"
    end
  end
end
