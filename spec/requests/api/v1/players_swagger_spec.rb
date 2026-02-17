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

      response "401", "Unauthorized" do
        description "Authentication token is missing or invalid"
        run_test!
      end
    end
  end
end
