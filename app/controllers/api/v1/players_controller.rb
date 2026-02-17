module Api
  module V1
    class PlayersController < ApplicationController
      def leaderboard
        query = Player.joins(:game_events)
                      .select('players.id, players.name, players.external_id, SUM(game_events.value) as total_xp')
                      .group('players.id, players.name, players.external_id')
                      .order('total_xp DESC')

        @players = query.page(params[:page])

        render json: {
          players: PlayerSerializer.render_as_hash(@players),
          meta: {
            current_page: @players.current_page,
            total_pages: @players.total_pages,
            total_count: @players.total_count
          }
        }
      end
    end
  end
end
