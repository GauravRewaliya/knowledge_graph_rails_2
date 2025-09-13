require 'rails_helper'

RSpec.describe "knowledge_queryfiers/show", type: :view do
  before(:each) do
    assign(:knowledge_queryfier, KnowledgeQueryfier.create!(
      user: nil,
      project: nil,
      cypher_dynamic_query: "MyText",
      meta_data_swagger_docs: "",
      tags: "Tags",
      title: "Title",
      description: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Tags/)
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/MyText/)
  end
end
