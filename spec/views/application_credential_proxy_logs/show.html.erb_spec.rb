require 'rails_helper'

RSpec.describe "application_credential_proxy_logs/show", type: :view do
  before(:each) do
    assign(:application_credential_proxy_log, ApplicationCredentialProxyLog.create!(
      application_doc: nil,
      application_credential: nil,
      user: nil,
      request_data: "",
      response_data: "",
      credits_used: "9.99",
      duration_ms: 2
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(/2/)
  end
end
