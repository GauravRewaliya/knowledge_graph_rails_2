require 'rails_helper'

RSpec.describe "knowledge_queryfiers/index", type: :view do
  before(:each) do
    assign(:knowledge_queryfiers, [
      KnowledgeQueryfier.create!(
        user: nil,
        project: nil,
        cypher_dynamic_query: "MyText",
        meta_data_swagger_docs: "",
        tags: "Tags",
        title: "Title",
        description: "MyText"
      ),
      KnowledgeQueryfier.create!(
        user: nil,
        project: nil,
        cypher_dynamic_query: "MyText",
        meta_data_swagger_docs: "",
        tags: "Tags",
        title: "Title",
        description: "MyText"
      )
    ])
  end

  it "renders a list of knowledge_queryfiers" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Tags".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Title".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
