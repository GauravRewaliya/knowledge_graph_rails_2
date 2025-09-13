require 'rails_helper'

RSpec.describe "db_scrappers/show", type: :view do
  before(:each) do
    assign(:db_scrapper, DbScrapper.create!(
      user: nil,
      project: nil,
      url: "Url",
      meta_data: "",
      source_provider: "Source Provider",
      sub_type: "Sub Type",
      response: "",
      fildered_response: "",
      parser_code: "MyText",
      final_response: "Final Response",
      knowledge_storage_cypher_code: "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Source Provider/)
    expect(rendered).to match(/Sub Type/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Final Response/)
    expect(rendered).to match(/MyText/)
  end
end
