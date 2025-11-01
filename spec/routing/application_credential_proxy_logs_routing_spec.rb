require "rails_helper"

RSpec.describe ApplicationCredentialProxyLogsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/application_credential_proxy_logs").to route_to("application_credential_proxy_logs#index")
    end

    it "routes to #new" do
      expect(get: "/application_credential_proxy_logs/new").to route_to("application_credential_proxy_logs#new")
    end

    it "routes to #show" do
      expect(get: "/application_credential_proxy_logs/1").to route_to("application_credential_proxy_logs#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/application_credential_proxy_logs/1/edit").to route_to("application_credential_proxy_logs#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/application_credential_proxy_logs").to route_to("application_credential_proxy_logs#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/application_credential_proxy_logs/1").to route_to("application_credential_proxy_logs#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/application_credential_proxy_logs/1").to route_to("application_credential_proxy_logs#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/application_credential_proxy_logs/1").to route_to("application_credential_proxy_logs#destroy", id: "1")
    end
  end
end
