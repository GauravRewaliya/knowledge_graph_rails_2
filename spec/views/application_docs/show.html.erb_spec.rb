require 'rails_helper'

RSpec.describe "application_docs/show", type: :view do
  before(:each) do
    assign(:application_doc, ApplicationDoc.create!(
      title: "Title",
      description: "MyText",
      base_url: "Base Url",
      tags: "MyText",
      is_active: false,
      docs: "",
      auth_fields: ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Base Url/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
  end
end
