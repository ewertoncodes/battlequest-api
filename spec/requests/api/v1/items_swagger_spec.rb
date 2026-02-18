require 'swagger_helper'

RSpec.describe 'api/v1/items', type: :request do
  path '/api/v1/items/top' do
    get 'Rank of most collected items' do
      tags 'Items'
      produces 'application/json'

      response '200', 'top items retrieved' do
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
