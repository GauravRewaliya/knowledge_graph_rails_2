require "rails_helper"

RSpec.describe KnowledgeQueryfiersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/knowledge_queryfiers").to route_to("knowledge_queryfiers#index")
    end

    it "routes to #new" do
      expect(get: "/knowledge_queryfiers/new").to route_to("knowledge_queryfiers#new")
    end

    it "routes to #show" do
      expect(get: "/knowledge_queryfiers/1").to route_to("knowledge_queryfiers#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/knowledge_queryfiers/1/edit").to route_to("knowledge_queryfiers#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/knowledge_queryfiers").to route_to("knowledge_queryfiers#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/knowledge_queryfiers/1").to route_to("knowledge_queryfiers#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/knowledge_queryfiers/1").to route_to("knowledge_queryfiers#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/knowledge_queryfiers/1").to route_to("knowledge_queryfiers#destroy", id: "1")
    end
  end
end
