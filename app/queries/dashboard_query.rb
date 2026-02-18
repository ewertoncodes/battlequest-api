class DashboardQuery
  ALLOWED_DASHBOARD_KEYS = %w[item_name quest_id boss_name item victim_id].freeze

  def initialize(relation = GameEvent.all)
    @relation = relation
  end

  def call
    {
      active_players: Player.joins(:game_events).merge(@relation).distinct.count,
      total_score: @relation.sum(:value),
      top_items: top_metadata_rank("ITEM_PICKUP", "item"),
      top_deaths: top_metadata_rank("PLAYER_DEATH", "victim_id"),
      bosses_defeated: top_metadata_rank("BOSS_DEFEAT", "boss_name")
    }
  end

  private

  def top_metadata_rank(event_type, metadata_key)
    return [] unless ALLOWED_DASHBOARD_KEYS.include?(metadata_key.to_s)

    @relation.where(event_type: event_type)
              .group(Arel.sql("metadata->>'#{metadata_key}'"))
             .order(Arel.sql("count_all DESC"))
             .limit(5)
             .count
             .map { |label, total| { label: label, total: total } }
  end
end
