class Api::V1::ItemsController < ApplicationController
  TOP_LIMIT = 10

  def top
    top_items = GameEvent.where(event_type: "ITEM_PICKUP")
                                  .group("metadata->>'item'")
                                  .order("count_all DESC")
                                  .limit(TOP_LIMIT)
                                  .count

    formatted_response = top_items.map do |item_id, total|
      { item: item_id, total: total }
    end

    render json: formatted_response
  end
end
