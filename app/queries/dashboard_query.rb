class DashboardQuery
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
    @relation.where(event_type: event_type)
             .group("metadata->>'#{metadata_key}'")
             .order("count_all DESC")
             .limit(5)
             .count
             .map { |label, total| { label: label, total: total } }
  end
end
