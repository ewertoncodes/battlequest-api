# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.openapi_root = Rails.root.join('swagger').to_s

  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'BattleQuest Game API',
        version: 'v1',
        description: 'Documentation for the Game Log Processing and Player Statistics API'
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
        }
      }
    }
  }

  config.openapi_format = :yaml
end
