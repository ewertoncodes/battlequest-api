require 'rails_helper'

RSpec.describe LogImporterService do
  let(:file_path) { 'spec/fixtures/game_test.log' }
  let(:log_line) { "2026-02-16 22:00:00 [COMBAT] BOSS_DEFEAT boss_name=GolemKing defeated_by=p1 xp=500" }

  before do
    allow(File).to receive(:exist?).with(file_path).and_return(true)
    allow(File).to receive(:foreach).with(file_path).and_yield(log_line).and_yield(log_line)
  end

  describe '#call' do
    it 'creates exactly one player even if the log has duplicate entries' do
      expect { described_class.new(file_path).call }.to change(Player, :count).by(1)
    end

    it 'creates exactly one event due to idempotency' do
      expect { described_class.new(file_path).call }.to change(GameEvent, :count).by(1)
    end

    it 'assigns the correct numeric value to the event' do
      described_class.new(file_path).call
      expect(GameEvent.last.value).to eq(500)
    end
  end
end
