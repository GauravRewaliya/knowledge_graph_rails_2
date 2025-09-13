require "rails_helper"

RSpec.describe DbScrappersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/db_scrappers").to route_to("db_scrappers#index")
    end

    it "routes to #new" do
      expect(get: "/db_scrappers/new").to route_to("db_scrappers#new")
    end

    it "routes to #show" do
      expect(get: "/db_scrappers/1").to route_to("db_scrappers#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/db_scrappers/1/edit").to route_to("db_scrappers#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/db_scrappers").to route_to("db_scrappers#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/db_scrappers/1").to route_to("db_scrappers#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/db_scrappers/1").to route_to("db_scrappers#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/db_scrappers/1").to route_to("db_scrappers#destroy", id: "1")
    end
  end
end
