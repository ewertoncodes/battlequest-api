class Player < ApplicationRecord
  has_many :game_events, dependent: :destroy

  validates :external_id, presence: true, uniqueness: true
  validates :name, presence: true
end
