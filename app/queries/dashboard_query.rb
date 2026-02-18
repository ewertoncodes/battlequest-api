class DashboardQuery
  DASHBOARD_SQL = <<~SQL.freeze
    SELECT 
      COUNT(DISTINCT ge.player_id) AS active_players,
      COALESCE(SUM(ge.value), 0) AS total_score,

      (SELECT json_agg(t) FROM (
      SELECT metadata->>'item' AS label, COUNT(*) AS total 
      FROM game_events WHERE event_type = 'ITEM_PICKUP' 
      GROUP BY 1 ORDER BY 2 DESC LIMIT 5
      ) t) AS top_items,

      (SELECT json_agg(d) FROM (
      SELECT p.name AS label, COUNT(*) AS total 
      FROM game_events ge
      JOIN players p ON p.external_id = ge.metadata->>'victim_id'
      WHERE ge.event_type = 'PLAYER_DEATH' 
      GROUP BY p.name ORDER BY 2 DESC LIMIT 5
      ) d) AS top_deaths,

      (SELECT json_agg(b) FROM (
      SELECT metadata->>'boss_name' AS label, COUNT(*) AS total 
      FROM game_events WHERE event_type = 'BOSS_DEFEAT' 
      GROUP BY 1 ORDER BY 2 DESC LIMIT 5
      ) b) AS bosses_defeated

    FROM game_events ge;
    SQL

  def initialize(relation = GameEvent.all)
    @relation = relation
  end

  def call
    result = ActiveRecord::Base.connection.execute(DASHBOARD_SQL).first

    {
      active_players:  result["active_players"].to_i,
      total_score:     result["total_score"].to_i,
      top_items:       parse_json(result["top_items"]),
      top_deaths:      parse_json(result["top_deaths"]),
      bosses_defeated: parse_json(result["bosses_defeated"])
    }
  end

  private

  def parse_json(value)
    JSON.parse(value || "[]")
  end
end
