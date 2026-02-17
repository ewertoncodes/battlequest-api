namespace :logs do
  desc "Import game events from log file"
  task import: :environment do
    file_path = Rails.root.join('game_log_large.txt')
    
    unless File.exist?(file_path)
      puts "❌ Arquivo não encontrado em: #{file_path}"
      next
    end

    puts "⏳ Iniciando importação..."
    
    Importer = LogImporterService.new(file_path)
    Importer.call

    puts "✅ Importação concluída!"
    puts "📊 Jogadores: #{Player.count}"
    puts "📊 Eventos: #{GameEvent.count}"
  end
end
