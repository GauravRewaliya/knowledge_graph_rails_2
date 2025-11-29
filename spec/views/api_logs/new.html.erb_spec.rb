require 'rails_helper'

RSpec.describe "api_logs/new", type: :view do
  before(:each) do
    assign(:api_log, ApiLog.new(
      method: "MyString",
      target_url: "MyString",
      request: "",
      response: ""
    ))
  end

  it "renders new api_log form" do
    render

    assert_select "form[action=?][method=?]", api_logs_path, "post" do

      assert_select "input[name=?]", "api_log[method]"

      assert_select "input[name=?]", "api_log[target_url]"

      assert_select "input[name=?]", "api_log[request]"

      assert_select "input[name=?]", "api_log[response]"
    end
  end
end
