require "rails_helper"

RSpec.describe ApplicationDocsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/application_docs").to route_to("application_docs#index")
    end

    it "routes to #new" do
      expect(get: "/application_docs/new").to route_to("application_docs#new")
    end

    it "routes to #show" do
      expect(get: "/application_docs/1").to route_to("application_docs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/application_docs/1/edit").to route_to("application_docs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/application_docs").to route_to("application_docs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/application_docs/1").to route_to("application_docs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/application_docs/1").to route_to("application_docs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/application_docs/1").to route_to("application_docs#destroy", id: "1")
    end
  end
end
