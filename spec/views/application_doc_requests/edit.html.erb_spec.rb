require 'rails_helper'

RSpec.describe "application_doc_requests/edit", type: :view do
  let(:application_doc_request) {
    ApplicationDocRequest.create!(
      application_doc: nil,
      title: "MyString",
      description: "MyText",
      curl_template: "MyText",
      swagger_data: ""
    )
  }

  before(:each) do
    assign(:application_doc_request, application_doc_request)
  end

  it "renders the edit application_doc_request form" do
    render

    assert_select "form[action=?][method=?]", application_doc_request_path(application_doc_request), "post" do

      assert_select "input[name=?]", "application_doc_request[application_doc_id]"

      assert_select "input[name=?]", "application_doc_request[title]"

      assert_select "textarea[name=?]", "application_doc_request[description]"

      assert_select "textarea[name=?]", "application_doc_request[curl_template]"

      assert_select "input[name=?]", "application_doc_request[swagger_data]"
    end
  end
end
