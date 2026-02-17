class LogImporterService
  PLAYER_KEYS = %i[player_id defeated_by id victim_id killer_id].freeze

  def initialize(file_path)
    @file_path = file_path
  end

  def call
    return unless File.exist?(@file_path)

    File.foreach(@file_path) { |line| process_line(line) }
  end

  private

  def process_line(line)
    parsed = LogParserService.new(line).call
    return unless parsed

    player = find_or_create_player(parsed[:metadata])
    persist_event(player, parsed) if player
  end

  def find_or_create_player(metadata)
    external_id = PLAYER_KEYS.map { |key| metadata[key] }.compact.first
    return unless external_id

    Player.find_or_create_by!(external_id: external_id) do |p|
      p.name = metadata[:name] || "Player #{external_id}"
    end
  end

  def persist_event(player, data)
    GameEvent.find_or_create_by!(
      player: player,
      event_type: data[:event_type],
      occurred_at: data[:timestamp]
    ) do |event|
      event.category = data[:category]
      event.metadata = data[:metadata]
      event.value = (data[:metadata][:xp] || data[:metadata][:gold] || 0).to_i
    end
  end
end
