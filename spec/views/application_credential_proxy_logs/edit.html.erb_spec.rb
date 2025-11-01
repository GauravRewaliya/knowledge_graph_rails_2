require 'rails_helper'

RSpec.describe "application_credential_proxy_logs/edit", type: :view do
  let(:application_credential_proxy_log) {
    ApplicationCredentialProxyLog.create!(
      application_doc: nil,
      application_credential: nil,
      user: nil,
      request_data: "",
      response_data: "",
      credits_used: "9.99",
      duration_ms: 1
    )
  }

  before(:each) do
    assign(:application_credential_proxy_log, application_credential_proxy_log)
  end

  it "renders the edit application_credential_proxy_log form" do
    render

    assert_select "form[action=?][method=?]", application_credential_proxy_log_path(application_credential_proxy_log), "post" do

      assert_select "input[name=?]", "application_credential_proxy_log[application_doc_id]"

      assert_select "input[name=?]", "application_credential_proxy_log[application_credential_id]"

      assert_select "input[name=?]", "application_credential_proxy_log[user_id]"

      assert_select "input[name=?]", "application_credential_proxy_log[request_data]"

      assert_select "input[name=?]", "application_credential_proxy_log[response_data]"

      assert_select "input[name=?]", "application_credential_proxy_log[credits_used]"

      assert_select "input[name=?]", "application_credential_proxy_log[duration_ms]"
    end
  end
end
