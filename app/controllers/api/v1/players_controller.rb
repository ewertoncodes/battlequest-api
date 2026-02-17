module Api
  module V1
    class PlayersController < ApplicationController
      def index
        players = Player.order(:name).page(params[:page])
        render json: {
          players: PlayerSerializer.render_as_hash(players), # View padrão
          meta: pagination_meta(players)
        }
      end

      def leaderboard
        players = Player.select("players.*, SUM(game_events.value) as total_xp")
                        .joins(:game_events)
                        .where(game_events: { event_type: "xp_gain" })
                        .group("players.id")
                        .order("total_xp DESC")
                        .page(params[:page])

        render json: {
          players: PlayerSerializer.render_as_hash(players, view: :leaderboard), # View com XP
          meta: pagination_meta(players)
        }
      end
      private

      def pagination_meta(collection)
        {
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end
    end
  end
end
