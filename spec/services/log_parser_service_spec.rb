require 'rails_helper'

RSpec.describe LogParserService do
  let(:combat_line) { '2025-08-04 14:00:27 [COMBAT] BOSS_DEFEAT boss_name=GolemKing defeated_by=p2 xp=4752 gold=483' }
  let(:chat_line) { '2025-08-31 11:36:10 [CHAT] MESSAGE player_id=p3 message="Let\'s go!"' }
  let(:info_line) { '2025-08-31 11:36:38 [INFO] PLAYER_JOIN id=p3 name=Charlie level=19 zone=MysticLake' }

  describe '#call' do
    context 'with a combat log line' do
      it 'extracts basic attributes correctly' do
        result = LogParserService.new(combat_line).call

        expect(result[:timestamp]).to eq('2025-08-04 14:00:27')
        expect(result[:category]).to eq('COMBAT')
        expect(result[:event_type]).to eq('BOSS_DEFEAT')
      end

      it 'extracts combat metadata' do
        result = LogParserService.new(combat_line).call

        expect(result[:metadata][:boss_name]).to eq('GolemKing')
        expect(result[:metadata][:defeated_by]).to eq('p2')
        expect(result[:metadata][:xp]).to eq('4752')
      end
    end

    context 'with a chat log line' do
      it 'handles quoted messages in metadata' do
        result = LogParserService.new(chat_line).call

        expect(result[:metadata][:message]).to eq("Let's go!")
        expect(result[:metadata][:player_id]).to eq('p3')
      end
    end

    context 'with an info log line' do
      it 'extracts player join details' do
        result = LogParserService.new(info_line).call

        expect(result[:metadata][:id]).to eq('p3')
        expect(result[:metadata][:name]).to eq('Charlie')
      end
    end

    context 'with an invalid line' do
      it 'returns nil' do
        expect(LogParserService.new('invalid line').call).to be_nil
      end
    end
  end
end
