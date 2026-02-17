class PlayerSerializer < Blueprinter::Base
  identifier :external_id

  fields :name

  field :total_xp do |player|
    player.total_xp.to_i
  end
end
