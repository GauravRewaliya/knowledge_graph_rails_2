require 'rails_helper'

RSpec.describe "application_docs/index", type: :view do
  before(:each) do
    assign(:application_docs, [
      ApplicationDoc.create!(
        title: "Title",
        description: "MyText",
        base_url: "Base Url",
        tags: "MyText",
        is_active: false,
        docs: "",
        auth_fields: ""
      ),
      ApplicationDoc.create!(
        title: "Title",
        description: "MyText",
        base_url: "Base Url",
        tags: "MyText",
        is_active: false,
        docs: "",
        auth_fields: ""
      )
    ])
  end

  it "renders a list of application_docs" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Base Url".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new(false.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
  end
end
