require "rails_helper"

RSpec.describe UserCreditsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/user_credits").to route_to("user_credits#index")
    end

    it "routes to #new" do
      expect(get: "/user_credits/new").to route_to("user_credits#new")
    end

    it "routes to #show" do
      expect(get: "/user_credits/1").to route_to("user_credits#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/user_credits/1/edit").to route_to("user_credits#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/user_credits").to route_to("user_credits#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/user_credits/1").to route_to("user_credits#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/user_credits/1").to route_to("user_credits#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/user_credits/1").to route_to("user_credits#destroy", id: "1")
    end
  end
end
