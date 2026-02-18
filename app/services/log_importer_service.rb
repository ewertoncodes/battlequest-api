class LogImporterService
  BATCH_SIZE = 1000

  def initialize(file_path)
    @file_path = file_path
    @players_cache = Player.pluck(:external_id, :id).to_h
    last_event = GameEvent.maximum(:occurred_at)
    @cutoff_time = last_event ? (last_event - 1.day) : Time.at(0)
  end

  def call
    return unless File.exist?(@file_path)

    File.foreach(@file_path).lazy
        .map { |line| parse_and_prepare(line) }
        .compact
        .reject { |event| event[:occurred_at] <= @cutoff_time }
        .each_slice(BATCH_SIZE) do |batch|
          GameEvent.insert_all(batch, unique_by: :idx_unique_game_events)
        end
  end

  private

  def parse_and_prepare(line)
    parsed = LogParserService.parse(line)
    return nil unless parsed

    ext_id = extract_external_id(parsed[:metadata])
    return nil unless ext_id

    player_id = @players_cache[ext_id.to_s] ||= find_or_create_player_id(ext_id, parsed[:metadata])

    {
      player_id:   player_id,
      event_type:  parsed[:event_type],
      category:    parsed[:category],
      metadata:    parsed[:metadata],
      value:       (parsed[:metadata][:xp] || parsed[:metadata][:gold] || 0).to_i,
      occurred_at: parsed[:timestamp],
      created_at:  Time.current,
      updated_at:  Time.current
    }
  end

  def extract_external_id(metadata)
    metadata.values_at(:player_id, :defeated_by, :id, :victim_id, :killer_id).compact.first
  end

  def find_or_create_player_id(ext_id, metadata)
    Player.find_or_create_by!(external_id: ext_id.to_s) do |p|
      p.name = metadata[:name] || "Player #{ext_id}"
    end.id
  end
end
