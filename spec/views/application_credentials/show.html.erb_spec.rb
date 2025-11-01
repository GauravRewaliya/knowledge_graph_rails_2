require 'rails_helper'

RSpec.describe "application_credentials/show", type: :view do
  before(:each) do
    assign(:application_credential, ApplicationCredential.create!(
      application_doc: nil,
      title: "Title",
      description: "MyText",
      credential_type: "Credential Type",
      rate_limits: "",
      settings: "",
      auth_data: "",
      is_active: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Credential Type/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
  end
end
