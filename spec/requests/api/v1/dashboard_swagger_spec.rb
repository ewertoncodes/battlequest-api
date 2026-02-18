require 'swagger_helper'

RSpec.describe 'api/v1/dashboard', type: :request do
  path '/api/v1/dashboard' do
    get('display analytics dashboard') do
      tags 'Dashboard'
      description 'Returns consolidated game metrics, including active players, total score, and rankings.'
      produces 'application/json'

      response(200, 'Dashboard loaded successfully') do
        schema type: :object,
               properties: {
                 active_players: { type: :integer, description: 'Total number of unique players with recorded events', example: 42 },
                 total_score: { type: :integer, description: 'Sum of all accumulated XP/Gold values', example: 15400 },
                 top_items: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       label: { type: :string, example: 'Health Potion' },
                       total: { type: :integer, example: 150 }
                     }
                   }
                 },
                 top_deaths: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       label: { type: :string, description: 'ID of the player who died', example: 'p123' },
                       total: { type: :integer, example: 5 }
                     }
                   }
                 },
                 bosses_defeated: {
                   type: :array,
                   items: {
                     type: :object,
                     properties: {
                       label: { type: :string, description: 'Name of the defeated boss', example: 'Dragon Lord' },
                       total: { type: :integer, example: 12 }
                     }
                   }
                 }
               },
               required: %w[active_players total_score top_items top_deaths bosses_defeated]

        run_test!
      end
    end
  end
end
