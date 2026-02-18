require 'rails_helper'

RSpec.describe LogParserService do
  let(:combat_line) { "2024-03-20 10:00:00 [GAME] xp_gain player_id=123 name=\"Hero\" xp=50" }
  let(:chat_line)   { "2024-03-20 10:01:00 [CHAT] message sender=\"Player1\" text=\"Hello world!\"" }
  let(:info_line)   { "2024-03-20 10:02:00 [INFO] player_join id=99 name=Newbie" }

  describe ".parse" do
    context "with a combat log line" do
      it "extracts basic attributes correctly" do
        result = LogParserService.parse(combat_line)
        expect(result[:event_type]).to eq('xp_gain')
        expect(result[:category]).to eq('GAME')
      end

      it "extracts combat metadata" do
        result = LogParserService.parse(combat_line)
        expect(result[:metadata][:player_id]).to eq('123')
        expect(result[:metadata][:xp]).to eq('50')
      end
    end

    context "with a chat log line" do
      it "handles quoted messages in metadata" do
        result = LogParserService.parse(chat_line)
        expect(result[:metadata][:text]).to eq('Hello world!')
      end
    end

    context "with an info log line" do
      it "extracts player join details" do
        result = LogParserService.parse(info_line)
        expect(result[:metadata][:id]).to eq('99')
      end
    end

    context "with an invalid line" do
      it "returns nil" do
        expect(LogParserService.parse('invalid line')).to be_nil
      end
    end
  end
end
