class AddUniqueIndexToGameEvents < ActiveRecord::Migration[8.0]
  def change
    add_index :game_events, [ :occurred_at, :event_type, :player_id, :value ],
              unique: true,
              name: 'idx_unique_game_events'
  end
end
