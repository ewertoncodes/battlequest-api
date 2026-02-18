require 'rails_helper'

RSpec.describe "Api::V1::Dashboards", type: :request do
  include_context "with authenticated user"

  describe "GET /api/v1/dashboard" do
    context "when authenticated" do
      it "responds with success and correct schema" do
        get "/api/v1/dashboard", headers: auth_headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to have_key('active_players')
      end
    end
    context 'when are not authenticated' do
      it 'responds with unauthorized status' do
        get "/api/v1/dashboard"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
