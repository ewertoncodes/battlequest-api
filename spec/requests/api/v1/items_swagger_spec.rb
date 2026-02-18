require 'swagger_helper'

RSpec.describe 'api/v1/items', type: :request do
  path '/api/v1/items/top' do
    get 'Rank of most collected items' do
      tags 'Items'
      security [ api_key: [] ]
      produces 'application/json'

      response '200', 'top items retrieved' do
        include_context "with authenticated user"
        let(:'X-Api-Key') { authenticated_api_key.token }
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   item: { type: :string },
                   total: { type: :integer }
                 }
               }
        run_test!
      end
    end
  end
end
