require 'rails_helper'

RSpec.describe "application_doc_requests/show", type: :view do
  before(:each) do
    assign(:application_doc_request, ApplicationDocRequest.create!(
      application_doc: nil,
      title: "Title",
      description: "MyText",
      curl_template: "MyText",
      swagger_data: ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
  end
end
