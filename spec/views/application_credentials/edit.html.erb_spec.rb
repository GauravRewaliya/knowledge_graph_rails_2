require 'rails_helper'

RSpec.describe "application_credentials/edit", type: :view do
  let(:application_credential) {
    ApplicationCredential.create!(
      application_doc: nil,
      title: "MyString",
      description: "MyText",
      credential_type: "MyString",
      rate_limits: "",
      settings: "",
      auth_data: "",
      is_active: false
    )
  }

  before(:each) do
    assign(:application_credential, application_credential)
  end

  it "renders the edit application_credential form" do
    render

    assert_select "form[action=?][method=?]", application_credential_path(application_credential), "post" do

      assert_select "input[name=?]", "application_credential[application_doc_id]"

      assert_select "input[name=?]", "application_credential[title]"

      assert_select "textarea[name=?]", "application_credential[description]"

      assert_select "input[name=?]", "application_credential[credential_type]"

      assert_select "input[name=?]", "application_credential[rate_limits]"

      assert_select "input[name=?]", "application_credential[settings]"

      assert_select "input[name=?]", "application_credential[auth_data]"

      assert_select "input[name=?]", "application_credential[is_active]"
    end
  end
end
