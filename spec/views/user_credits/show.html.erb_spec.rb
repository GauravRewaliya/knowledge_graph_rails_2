require 'rails_helper'

RSpec.describe "user_credits/show", type: :view do
  before(:each) do
    assign(:user_credit, UserCredit.create!(
      user: nil,
      total_credits: "9.99",
      used_credits: "9.99",
      current_balance: "9.99"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/9.99/)
  end
end
