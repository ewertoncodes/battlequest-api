class GameEvent < ApplicationRecord
  belongs_to :player

  validates :category, :event_type, :occurred_at, presence: true

  scope :most_recent, ->(limit_count) {
    includes(:player).order(occurred_at: :desc).limit(limit_count)
  }
end
