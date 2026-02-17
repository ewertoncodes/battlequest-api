class PlayerSerializer < Blueprinter::Base
  identifier :id

  fields :name, :external_id
  view :leaderboard do
    field :total_xp do |player|
      player.total_xp.to_i
    end
  end
end
