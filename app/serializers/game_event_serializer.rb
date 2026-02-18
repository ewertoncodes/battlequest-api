class GameEventSerializer < Blueprinter::Base
  identifier :id

  fields :event_type, :category, :value, :occurred_at, :metadata

  association :player, blueprint: PlayerSerializer
end
