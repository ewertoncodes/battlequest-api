class PlayerSerializer < Blueprinter::Base
  identifier :id

  fields :name, :external_id

  view :leaderboard do
    field :total_xp do |player|
      player.total_xp.to_i
    end
  end

  view :stats do
    field :player_name do |player|
      player.name
    end
    field :total_xp do |player|
      player.game_events.where(event_type: "xp_gain").sum(:value)
    end
    field :deaths do |player|
      player.game_events.where(event_type: "death").count
    end
    field :items_collected do |player|
      player.game_events.where(event_type: "item_pickup").count
    end
  end
end
