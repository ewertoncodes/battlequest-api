require 'rails_helper'

RSpec.describe "Api::V1::Dashboards", type: :request do
  describe "GET /api/v1/dashboard" do
    it "responds with success and correct schema" do
      get "/api/v1/dashboard"
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to have_key('active_players')
    end
  end
end
