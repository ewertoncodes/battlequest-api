class AddValueToGameEvents < ActiveRecord::Migration[8.0]
  def change
    add_column :game_events, :value, :integer
  end
end
