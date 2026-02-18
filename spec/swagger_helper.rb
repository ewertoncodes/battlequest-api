# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Battlequest API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Local Development Server'
        }
      ],
      components: {
        schemas: {
          player: {
            type: :object,
            properties: {
              id: { type: :integer },
              external_id: { type: :string },
              name: { type: :string },
              created_at: { type: :string, format: 'date-time' }
            },
            required: %w[id name]
          },
          pagination_meta: {
            type: :object,
            properties: {
              current_page: { type: :integer, example: 1 },
              next_page: { type: :integer, example: 2, nullable: true },
              prev_page: { type: :integer, example: nil, nullable: true },
              total_pages: { type: :integer, example: 5 },
              total_count: { type: :integer, example: 120 }
            }
          },
          error_response: {
            type: :object,
            properties: {
              error: { type: :string, example: 'Resource not found' }
            }
          }
        },
        securitySchemes: {
          api_key: {
            type: :apiKey,
            name: 'X-Api-Key',
            in: :header
          }
        }
      },
      security: [ { api_key: [] } ]
    }
  }

  config.openapi_format = :yaml
end
