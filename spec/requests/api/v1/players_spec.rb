require 'rails_helper'

RSpec.describe "Api::V1::Players", type: :request do
  describe "GET /api/v1/players/leaderboard" do
    let!(:player_one) { create(:player, name: "Player One") }
    let!(:player_two) { create(:player, name: "Player Two") }

    let!(:event_one) { create(:game_event, player: player_one, value: 100) }
    let!(:event_two) { create(:game_event, player: player_one, value: 50) }
    let!(:event_three) { create(:game_event, player: player_two, value: 200) }

    it "returns leaderboard ordered by total_xp descending" do
      get "/api/v1/players/leaderboard"

      expect(response).to have_http_status(:success)
      json = JSON.parse(response.body)

      expect(json["players"].first["name"]).to eq("Player Two")
      expect(json["players"].first["total_xp"]).to eq(200)
      expect(json["players"].second["total_xp"]).to eq(150)
    end

    it "includes pagination metadata" do
      get "/api/v1/players/leaderboard"
      json = JSON.parse(response.body)

      expect(json).to have_key("meta")
      expect(json["meta"]["total_count"]).to eq(2)
    end
  end
end
