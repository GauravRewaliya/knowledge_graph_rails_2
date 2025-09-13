require 'rails_helper'

RSpec.describe "db_scrappers/edit", type: :view do
  let(:db_scrapper) {
    DbScrapper.create!(
      user: nil,
      project: nil,
      url: "MyString",
      meta_data: "",
      source_provider: "MyString",
      sub_type: "MyString",
      response: "",
      fildered_response: "",
      parser_code: "MyText",
      final_response: "MyString",
      knowledge_storage_cypher_code: "MyText"
    )
  }

  before(:each) do
    assign(:db_scrapper, db_scrapper)
  end

  it "renders the edit db_scrapper form" do
    render

    assert_select "form[action=?][method=?]", db_scrapper_path(db_scrapper), "post" do

      assert_select "input[name=?]", "db_scrapper[user_id]"

      assert_select "input[name=?]", "db_scrapper[project_id]"

      assert_select "input[name=?]", "db_scrapper[url]"

      assert_select "input[name=?]", "db_scrapper[meta_data]"

      assert_select "input[name=?]", "db_scrapper[source_provider]"

      assert_select "input[name=?]", "db_scrapper[sub_type]"

      assert_select "input[name=?]", "db_scrapper[response]"

      assert_select "input[name=?]", "db_scrapper[fildered_response]"

      assert_select "textarea[name=?]", "db_scrapper[parser_code]"

      assert_select "input[name=?]", "db_scrapper[final_response]"

      assert_select "textarea[name=?]", "db_scrapper[knowledge_storage_cypher_code]"
    end
  end
end
