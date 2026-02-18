class Api::V1::EventsController < ApplicationController
  DEFAULT_LIMIT = 50

def index
  limit = params[:limit].to_i
  limit = DEFAULT_LIMIT if limit <= 0

  @events = GameEvent.most_recent(limit)
  render json: GameEventSerializer.render(@events)
end
end
