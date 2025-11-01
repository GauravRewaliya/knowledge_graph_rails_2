require 'rails_helper'

RSpec.describe "application_docs/edit", type: :view do
  let(:application_doc) {
    ApplicationDoc.create!(
      title: "MyString",
      description: "MyText",
      base_url: "MyString",
      tags: [ "MyText" ],
      is_active: false,
      docs: "",
      auth_fields: ""
    )
  }

  before(:each) do
    assign(:application_doc, application_doc)
  end

  it "renders the edit application_doc form" do
    render

    assert_select "form[action=?][method=?]", application_doc_path(application_doc), "post" do
      assert_select "input[name=?]", "application_doc[title]"

      assert_select "textarea[name=?]", "application_doc[description]"

      assert_select "input[name=?]", "application_doc[base_url]"

      assert_select "input[name=?]", "application_doc[tags]"

      assert_select "input[name=?]", "application_doc[is_active]"

      assert_select "input[name=?]", "application_doc[docs]"

      assert_select "input[name=?]", "application_doc[auth_fields]"
    end
  end
end
