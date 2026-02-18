require 'rails_helper'

RSpec.describe LogImporterService do
  let(:fixtures_path) { Rails.root.join('spec/fixtures') }
  let(:file_path) { fixtures_path.join('small_log.log') }
  subject { described_class.new(file_path.to_s) }

  before do
    FileUtils.mkdir_p(fixtures_path) # Garante que a pasta existe
    File.write(file_path, "2024-03-20 10:00:00 [GAME] xp_gain player_id=1 xp=100\n")
  end

  after do
    File.delete(file_path) if File.exist?(file_path)
  end

  it "imports events in bulk successfully" do
    expect { subject.call }.to change(Player, :count).by(1)
      .and change(GameEvent, :count).by(1)

    event = GameEvent.last
    expect(event.value).to eq(100)
    expect(event.event_type).to eq('xp_gain')
  end
end
