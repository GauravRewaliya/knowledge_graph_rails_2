require 'rails_helper'

RSpec.describe "user_credits/index", type: :view do
  before(:each) do
    assign(:user_credits, [
      UserCredit.create!(
        user: nil,
        total_credits: "9.99",
        used_credits: "9.99",
        current_balance: "9.99"
      ),
      UserCredit.create!(
        user: nil,
        total_credits: "9.99",
        used_credits: "9.99",
        current_balance: "9.99"
      )
    ])
  end

  it "renders a list of user_credits" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
  end
end
