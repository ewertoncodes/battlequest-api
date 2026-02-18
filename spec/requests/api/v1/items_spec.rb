require 'rails_helper'

RSpec.describe "Api::V1::Items", type: :request do
  include_context "with authenticated user"
  describe "GET /api/v1/items/top" do
    context "when items exist" do
      let!(:player) { create(:player) }

      before do
        create_list(:game_event, 3, event_type: 'ITEM_PICKUP', metadata: { item: 'health_potion' }, player: player)
        create_list(:game_event, 2, event_type: 'ITEM_PICKUP', metadata: { item: 'iron_sword' }, player: player)
        create(:game_event, event_type: 'ITEM_PICKUP', metadata: { item: 'wooden_shield' }, player: player)
      end

      it "returns http success" do
        get "/api/v1/items/top", headers: auth_headers
        expect(response).to have_http_status(:ok)
      end

      it "returns the top items ranked by frequency" do
        get "/api/v1/items/top", headers: auth_headers
        json = JSON.parse(response.body)

        expect(json.size).to eq(3)
        expect(json.first['item']).to eq('health_potion')
        expect(json.first['total']).to eq(3)
        expect(json.last['item']).to eq('wooden_shield')
      end
    end

    context "when no items are found" do
      it "returns an empty array" do
        get "/api/v1/items/top", headers: auth_headers
        json = JSON.parse(response.body)
        expect(json).to be_empty
      end
    end

    context "when not authenticated" do
      it "returns http unauthorized" do
        get "/api/v1/items/top"
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
