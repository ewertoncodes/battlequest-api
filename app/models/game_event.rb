class GameEvent < ApplicationRecord
  belongs_to :player

  validates :category, :event_type, :occurred_at, presence: true
end
