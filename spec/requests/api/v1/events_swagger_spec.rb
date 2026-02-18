require 'swagger_helper'

RSpec.describe 'api/v1/events', type: :request do
  path '/api/v1/events' do
    get 'Retrieves game events' do
      tags 'Events'
      produces 'application/json'
      parameter name: :limit, in: :query, type: :integer, description: 'Number of events'

      let(:limit) { 10 }

      response '200', 'events found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   event_type: { type: :string },
                   category: { type: :string },
                   value: { type: :integer },
                   occurred_at: { type: :string, format: 'date-time' },
                   metadata: { type: :object },
                   player: { '$ref' => '#/components/schemas/player' }
                 }
               }
        run_test!
      end
    end
  end
end
