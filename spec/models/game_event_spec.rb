require 'rails_helper'

RSpec.describe GameEvent, type: :model do
  let(:player) { Player.create!(external_id: 'p1', name: 'Bob') }

  context 'when attributes are valid' do
    subject { GameEvent.new(player: player, category: 'COMBAT', event_type: 'DEATH', occurred_at: Time.current) }
    it { is_expected.to be_valid }
  end

  context 'when player is missing' do
    subject { GameEvent.new(player: nil, category: 'INFO', event_type: 'JOIN', occurred_at: Time.current) }
    it { is_expected.to be_invalid }
  end
end
