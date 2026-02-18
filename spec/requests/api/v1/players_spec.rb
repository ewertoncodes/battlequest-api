require 'rails_helper'

RSpec.describe "Api::V1::Players", type: :request do
  describe "GET /api/v1/players/leaderboard" do
    context "when players have earned XP" do
      let!(:player_one) { create(:player, name: "Player One") }
      let!(:player_two) { create(:player, name: "Player Two") }

      before do
        create(:game_event, player: player_one, value: 100, event_type: 'xp_gain')
        create(:game_event, player: player_one, value: 50, event_type: 'xp_gain')
        create(:game_event, player: player_two, value: 200, event_type: 'xp_gain')
      end

      it "returns leaderboard ordered by total_xp descending" do
        get "/api/v1/players/leaderboard"
        json = JSON.parse(response.body)

        expect(json["players"].first["name"]).to eq("Player Two")
        expect(json["players"].first["total_xp"]).to eq(200)
        expect(json["players"].second["total_xp"]).to eq(150)
      end

      it "includes correct pagination metadata" do
        get "/api/v1/players/leaderboard"
        json = JSON.parse(response.body)

        expect(json["meta"]["total_count"]).to eq(2)
      end
    end

    context "when no players have earned XP yet" do
      it "returns an empty players list" do
        get "/api/v1/players/leaderboard"
        json = JSON.parse(response.body)

        expect(json["players"]).to be_empty
        expect(json["meta"]["total_count"]).to eq(0)
      end
    end
  end

  describe "GET /api/v1/players" do
    context "when players exist" do
      let!(:players) { create_list(:player, 30) }

      it "returns a paginated list on page 1" do
        get "/api/v1/players", params: { page: 1 }
        json = JSON.parse(response.body)

        expect(json['players'].size).to eq(25) # Default kaminari
        expect(json['meta']['total_count']).to eq(30)
      end

      it "returns the remaining players on page 2" do
        get "/api/v1/players", params: { page: 2 }
        json = JSON.parse(response.body)

        expect(json['players'].size).to eq(5)
      end
    end

    context "when there are no players registered" do
      it "returns an empty array and success status" do
        get "/api/v1/players"
        json = JSON.parse(response.body)

        expect(response).to have_http_status(:ok)
        expect(json['players']).to eq([])
        expect(json['meta']['total_count']).to eq(0)
      end
    end
  end

  describe "GET /api/v1/players/:id/stats" do
    let!(:player) { create(:player, name: "Arthur Morgan") }

    context "when player exists" do
      before do
        create(:game_event, player: player, event_type: 'xp_gain', value: 100)
        create(:game_event, player: player, event_type: 'xp_gain', value: 50)
        create_list(:game_event, 3, player: player, event_type: 'death')
        create(:game_event, player: player, event_type: 'item_pickup')
      end

      it "returns correct accumulated statistics" do
        get "/api/v1/players/#{player.id}/stats"

        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)

        expect(json["player_name"]).to eq("Arthur Morgan")
        expect(json["total_xp"]).to eq(150)
        expect(json["deaths"]).to eq(3)
        expect(json["items_collected"]).to eq(1)
      end
    end

    context "when player does not exist" do
      it "returns 404 status" do
        get "/api/v1/players/0/stats"
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
