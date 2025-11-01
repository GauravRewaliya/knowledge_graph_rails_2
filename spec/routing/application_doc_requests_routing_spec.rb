require "rails_helper"

RSpec.describe ApplicationDocRequestsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/application_doc_requests").to route_to("application_doc_requests#index")
    end

    it "routes to #new" do
      expect(get: "/application_doc_requests/new").to route_to("application_doc_requests#new")
    end

    it "routes to #show" do
      expect(get: "/application_doc_requests/1").to route_to("application_doc_requests#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/application_doc_requests/1/edit").to route_to("application_doc_requests#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/application_doc_requests").to route_to("application_doc_requests#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/application_doc_requests/1").to route_to("application_doc_requests#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/application_doc_requests/1").to route_to("application_doc_requests#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/application_doc_requests/1").to route_to("application_doc_requests#destroy", id: "1")
    end
  end
end
