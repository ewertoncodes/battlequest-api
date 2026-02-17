class CreateGameEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :game_events do |t|
      t.string :category
      t.string :event_type
      t.datetime :occurred_at
      t.jsonb :metadata
      t.references :player, null: false, foreign_key: true

      t.timestamps
    end
    add_index :game_events, :event_type
  end
end
