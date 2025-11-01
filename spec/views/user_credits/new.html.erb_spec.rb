require 'rails_helper'

RSpec.describe "user_credits/new", type: :view do
  before(:each) do
    assign(:user_credit, UserCredit.new(
      user: nil,
      total_credits: "9.99",
      used_credits: "9.99",
      current_balance: "9.99"
    ))
  end

  it "renders new user_credit form" do
    render

    assert_select "form[action=?][method=?]", user_credits_path, "post" do

      assert_select "input[name=?]", "user_credit[user_id]"

      assert_select "input[name=?]", "user_credit[total_credits]"

      assert_select "input[name=?]", "user_credit[used_credits]"

      assert_select "input[name=?]", "user_credit[current_balance]"
    end
  end
end
