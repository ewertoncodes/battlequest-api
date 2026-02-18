class DashboardQuery
  def initialize(relation = GameEvent.all)
    @relation = relation
  end

  def call
    result = ActiveRecord::Base.connection.execute(dashboard_sql).first

    {
      active_players: result["active_players"].to_i,
      total_score:    result["total_score"].to_i,
      top_items:      parse_json(result["top_items"]),
      top_deaths:     parse_json(result["top_deaths"]),
      bosses_defeated: parse_json(result["bosses_defeated"])
    }
  end

  private

  def parse_json(value)
    JSON.parse(value || "[]")
  end

  def dashboard_sql
    <<-SQL
      SELECT#{' '}
        COUNT(DISTINCT player_id) AS active_players,
        COALESCE(SUM(value), 0) AS total_score,
      #{'  '}
        -- Top Items
        (SELECT json_agg(t) FROM (
          SELECT metadata->>'item' AS label, COUNT(*) AS total#{' '}
          FROM game_events WHERE event_type = 'ITEM_PICKUP'#{' '}
          GROUP BY 1 ORDER BY 2 DESC LIMIT 5
        ) t) AS top_items,

        -- Top Deaths
        (SELECT json_agg(d) FROM (
          SELECT metadata->>'victim_id' AS label, COUNT(*) AS total#{' '}
          FROM game_events WHERE event_type = 'PLAYER_DEATH'#{' '}
          GROUP BY 1 ORDER BY 2 DESC LIMIT 5
        ) d) AS top_deaths,

        -- Bosses Defeated
        (SELECT json_agg(b) FROM (
          SELECT metadata->>'boss_name' AS label, COUNT(*) AS total#{' '}
          FROM game_events WHERE event_type = 'BOSS_DEFEAT'#{' '}
          GROUP BY 1 ORDER BY 2 DESC LIMIT 5
        ) b) AS bosses_defeated
      #{'  '}
      FROM game_events;
    SQL
  end
end
