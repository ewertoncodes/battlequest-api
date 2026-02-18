class LogImporterService
  PLAYER_KEYS = %i[player_id defeated_by id victim_id killer_id].freeze
  BATCH_SIZE = 1000

  def initialize(file_path)
    @file_path = file_path
    @players_cache = Player.pluck(:external_id, :id).to_h
    @events_to_import = []
  end

  def call
    return unless File.exist?(@file_path)

    File.foreach(@file_path).with_index do |line, index|
      process_line(line)
      import_batch if (index % BATCH_SIZE).zero?
    end

    import_batch
  end

  private

  def process_line(line)
    parsed = LogParserService.parse(line)
    return unless parsed

    external_id = PLAYER_KEYS.map { |key| parsed[:metadata][key] }.compact.first
    return unless external_id

    player_id = @players_cache[external_id.to_s] || create_player(external_id, parsed[:metadata])

    @events_to_import << {
      player_id: player_id,
      event_type: parsed[:event_type],
      category: parsed[:category],
      metadata: parsed[:metadata],
      value: (parsed[:metadata][:xp] || parsed[:metadata][:gold] || 0).to_i,
      occurred_at: parsed[:timestamp],
      created_at: Time.current,
      updated_at: Time.current
    }
  end

  def create_player(external_id, metadata)
    player = Player.find_or_create_by!(external_id: external_id) do |p|
      p.name = metadata[:name] || "Player #{external_id}"
    end
    @players_cache[external_id.to_s] = player.id
    player.id
  end

  def import_batch
    return if @events_to_import.empty?
    GameEvent.insert_all(@events_to_import)
    @events_to_import = []
  end
end
