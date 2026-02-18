namespace :logs do
  desc "Import game events from log file"
  task import: :environment do
    file_path = Rails.root.join("game_log_large.txt")

    unless File.exist?(file_path)
      puts "❌ Arquivo não encontrado em: #{file_path}"
      next
    end

    start_time = Time.current
    puts "⏳ Iniciando importação de #{file_path}..."

    LogImporterService.new(file_path).call

    duration = Time.current - start_time
    puts "✅ Importação concluída em #{duration.round(2)}s!"
    puts "📊 Total de Jogadores: #{Player.count}"
    puts "📊 Total de Eventos:   #{GameEvent.count}"
  end
end
