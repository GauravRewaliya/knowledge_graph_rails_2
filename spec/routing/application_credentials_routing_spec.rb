require "rails_helper"

RSpec.describe ApplicationCredentialsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/application_credentials").to route_to("application_credentials#index")
    end

    it "routes to #new" do
      expect(get: "/application_credentials/new").to route_to("application_credentials#new")
    end

    it "routes to #show" do
      expect(get: "/application_credentials/1").to route_to("application_credentials#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/application_credentials/1/edit").to route_to("application_credentials#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/application_credentials").to route_to("application_credentials#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/application_credentials/1").to route_to("application_credentials#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/application_credentials/1").to route_to("application_credentials#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/application_credentials/1").to route_to("application_credentials#destroy", id: "1")
    end
  end
end
