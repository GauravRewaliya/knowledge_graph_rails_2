require "rails_helper"

RSpec.describe ApiLogsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/api_logs").to route_to("api_logs#index")
    end

    it "routes to #new" do
      expect(get: "/api_logs/new").to route_to("api_logs#new")
    end

    it "routes to #show" do
      expect(get: "/api_logs/1").to route_to("api_logs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/api_logs/1/edit").to route_to("api_logs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/api_logs").to route_to("api_logs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/api_logs/1").to route_to("api_logs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/api_logs/1").to route_to("api_logs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/api_logs/1").to route_to("api_logs#destroy", id: "1")
    end
  end
end
