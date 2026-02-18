class ApplicationController < ActionController::API
  before_action :authenticate_api_key!

  private

  def authenticate_api_key!
    token = request.headers["X-Api-Key"] || request.headers["Authorization"]&.split(" ")&.last

    unless ApiKey.exists?(token: token)
      render json: {
        error: "Unauthorized",
        message: "Generate a key with: rake api:generate_key"
      }, status: :unauthorized
    end
  end
end
