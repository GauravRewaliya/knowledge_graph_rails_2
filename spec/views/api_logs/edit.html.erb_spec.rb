require 'rails_helper'

RSpec.describe "api_logs/edit", type: :view do
  let(:api_log) {
    ApiLog.create!(
      method: "MyString",
      target_url: "MyString",
      request: "",
      response: ""
    )
  }

  before(:each) do
    assign(:api_log, api_log)
  end

  it "renders the edit api_log form" do
    render

    assert_select "form[action=?][method=?]", api_log_path(api_log), "post" do

      assert_select "input[name=?]", "api_log[method]"

      assert_select "input[name=?]", "api_log[target_url]"

      assert_select "input[name=?]", "api_log[request]"

      assert_select "input[name=?]", "api_log[response]"
    end
  end
end
