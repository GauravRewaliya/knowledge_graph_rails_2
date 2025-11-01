require 'rails_helper'

RSpec.describe "application_doc_requests/index", type: :view do
  before(:each) do
    assign(:application_doc_requests, [
      ApplicationDocRequest.create!(
        application_doc: nil,
        title: "Title",
        description: "MyText",
        curl_template: "MyText",
        swagger_data: ""
      ),
      ApplicationDocRequest.create!(
        application_doc: nil,
        title: "Title",
        description: "MyText",
        curl_template: "MyText",
        swagger_data: ""
      )
    ])
  end

  it "renders a list of application_doc_requests" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
  end
end
