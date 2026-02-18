require 'rails_helper'

RSpec.describe "Api::V1::Events", type: :request do
  include_context "with authenticated user"
  describe "GET /api/v1/events" do
    let!(:player) { create(:player) }

    before do
      create_list(:game_event, 60, player: player)
    end
    context 'when authenticated' do
      it "returns http success" do
        get "/api/v1/events", headers: auth_headers
        expect(response).to have_http_status(:ok)
      end

      it "returns the default limit of 50 events" do
        get "/api/v1/events", headers: auth_headers
        json = JSON.parse(response.body)
        expect(json.size).to eq(50)
      end

      it "respects the limit parameter" do
        get "/api/v1/events", params: { limit: 10 }, headers: auth_headers
        json = JSON.parse(response.body)
        expect(json.size).to eq(10)
      end

      it "returns events in descending chronological order" do
        future_event = create(:game_event, player: player, occurred_at: 1.day.from_now)

        get "/api/v1/events", params: { limit: 1 }, headers: auth_headers
        json = JSON.parse(response.body)

        expect(json.first['id']).to eq(future_event.id)
      end
    end
    context 'when are not authenticated' do
      it 'responds with unauthorized status' do
        get "/api/v1/events"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
