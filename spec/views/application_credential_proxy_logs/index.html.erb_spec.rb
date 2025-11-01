require 'rails_helper'

RSpec.describe "application_credential_proxy_logs/index", type: :view do
  before(:each) do
    assign(:application_credential_proxy_logs, [
      ApplicationCredentialProxyLog.create!(
        application_doc: nil,
        application_credential: nil,
        user: nil,
        request_data: "",
        response_data: "",
        credits_used: "9.99",
        duration_ms: 2
      ),
      ApplicationCredentialProxyLog.create!(
        application_doc: nil,
        application_credential: nil,
        user: nil,
        request_data: "",
        response_data: "",
        credits_used: "9.99",
        duration_ms: 2
      )
    ])
  end

  it "renders a list of application_credential_proxy_logs" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("9.99".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(2.to_s), count: 2
  end
end
