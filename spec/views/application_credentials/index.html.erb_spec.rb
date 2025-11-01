require 'rails_helper'

RSpec.describe "application_credentials/index", type: :view do
  before(:each) do
    assign(:application_credentials, [
      ApplicationCredential.create!(
        application_doc: nil,
        title: "Title",
        description: "MyText",
        credential_type: "Credential Type",
        rate_limits: "",
        settings: "",
        auth_data: "",
        is_active: false
      ),
      ApplicationCredential.create!(
        application_doc: nil,
        title: "Title",
        description: "MyText",
        credential_type: "Credential Type",
        rate_limits: "",
        settings: "",
        auth_data: "",
        is_active: false
      )
    ])
  end

  it "renders a list of application_credentials" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Credential Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
  end
end
