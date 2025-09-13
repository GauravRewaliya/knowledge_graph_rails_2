require 'rails_helper'

RSpec.describe "knowledge_queryfiers/new", type: :view do
  before(:each) do
    assign(:knowledge_queryfier, KnowledgeQueryfier.new(
      user: nil,
      project: nil,
      cypher_dynamic_query: "MyText",
      meta_data_swagger_docs: "",
      tags: "MyString",
      title: "MyString",
      description: "MyText"
    ))
  end

  it "renders new knowledge_queryfier form" do
    render

    assert_select "form[action=?][method=?]", knowledge_queryfiers_path, "post" do

      assert_select "input[name=?]", "knowledge_queryfier[user_id]"

      assert_select "input[name=?]", "knowledge_queryfier[project_id]"

      assert_select "textarea[name=?]", "knowledge_queryfier[cypher_dynamic_query]"

      assert_select "input[name=?]", "knowledge_queryfier[meta_data_swagger_docs]"

      assert_select "input[name=?]", "knowledge_queryfier[tags]"

      assert_select "input[name=?]", "knowledge_queryfier[title]"

      assert_select "textarea[name=?]", "knowledge_queryfier[description]"
    end
  end
end
