require 'rails_helper'

RSpec.describe "db_scrappers/index", type: :view do
  before(:each) do
    assign(:db_scrappers, [
      DbScrapper.create!(
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
      ),
      DbScrapper.create!(
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
      )
    ])
  end

  it "renders a list of db_scrappers" do
    render
    cell_selector = 'div>p'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Url".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Source Provider".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Sub Type".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Final Response".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("MyText".to_s), count: 2
  end
end
