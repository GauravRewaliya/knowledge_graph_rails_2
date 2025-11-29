require 'rails_helper'

RSpec.describe "api_logs/index", type: :view do
  before(:each) do
    assign(:api_logs, [
      ApiLog.create!(
        method: "Method",
        target_url: "Target Url",
        request: "",
        response: ""
      ),
      ApiLog.create!(
        method: "Method",
        target_url: "Target Url",
        request: "",
        response: ""
      )
    ])
  end

  it "renders a list of api_logs" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Method".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Target Url".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
  end
end
