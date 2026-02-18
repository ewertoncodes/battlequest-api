require "swagger_helper"

RSpec.describe "Api::V1::Players", type: :request do
  path "/api/v1/players/leaderboard" do
    get "Retrieve players ranking based on total XP" do
      tags "Leaderboard"
      description "Returns a paginated list of players ordered by their accumulated XP from game events."
      produces "application/json"
      parameter name: :page, in: :query, type: :integer, description: "Page number for pagination", required: false

      response "200", "Leaderboard retrieved successfully" do
        schema type: :object,
               properties: {
                 players: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer, example: 1 },
                       name: { type: :string, example: "Player One" },
                       external_id: { type: :string, example: "p_123" },
                       total_xp: { type: :integer, example: 5500 }
                     }
                   }
                 },
                 meta: {
                   type: :object,
                   properties: {
                     current_page: { type: :integer, example: 1 },
                     total_pages: { type: :integer, example: 5 },
                     total_count: { type: :integer, example: 100 }
                   }
                 }
               }

        run_test!
      end
    end
  end

  path "/api/v1/players" do
    get "List all players" do
      tags "Players"
      description "Returns a paginated list of all players with basic information."
      produces "application/json"
      parameter name: :page, in: :query, type: :integer, required: false, description: "Page number"

      response "200", "Success" do
        schema type: :object,
               properties: {
                 players: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       id: { type: :integer },
                       name: { type: :string },
                       external_id: { type: :string }
                     }
                   }
                 },
                 meta: { "$ref" => "#/components/schemas/pagination_meta" }
               }
        run_test!
      end
    end
  end

  path "/api/v1/players/{id}/stats" do
    get "Retrieve player statistics" do
      tags "Players"
      produces "application/json"
      parameter name: :id, in: :path, type: :integer, description: "Player ID"

      response "200", "Success" do
        let(:player) { create(:player) }
        let(:id) { player.id }

        schema type: :object,
               properties: {
                 player_name: { type: :string },
                 total_xp: { type: :integer },
                 deaths: { type: :integer },
                 items_collected: { type: :integer }
               }
        run_test!
      end

      response "404", "Player not found" do
        let(:id) { 0 }

        schema "$ref" => "#/components/schemas/error_response"
        run_test!
      end
    end
  end
end
