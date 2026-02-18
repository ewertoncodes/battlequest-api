class ChangeMetadataToOptionalJsonbInGameEvents < ActiveRecord::Migration[7.1]
  def up
    change_column :game_events, :metadata, :jsonb, using: 'metadata::jsonb', default: {}, null: false
    add_index :game_events, :metadata, using: :gin
  end

  def down
    change_column :game_events, :metadata, :text, using: 'metadata::text', default: nil, null: true
    remove_index :game_events, :metadata
  end
end
