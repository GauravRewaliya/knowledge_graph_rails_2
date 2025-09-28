require 'rails_helper'

RSpec.describe "knowledge_queryfiers/edit", type: :view do
  let(:knowledge_queryfier) {
    KnowledgeQueryfier.create!(
      user: nil,
      project: nil,
      cypher_dynamic_query: "MyText",
      meta_data_swagger_docs: "",
      tags: "MyString",
      title: "MyString",
      description: "MyText"
    )
  }

  before(:each) do
    assign(:knowledge_queryfier, knowledge_queryfier)
  end

  it "renders the edit knowledge_queryfier form" do
    render

    assert_select "form[action=?][method=?]", knowledge_queryfier_path(knowledge_queryfier), "post" do
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
