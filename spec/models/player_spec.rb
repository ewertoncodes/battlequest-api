require 'rails_helper'

RSpec.describe Player, type: :model do
  subject(:player) { Player.new(external_id: 'p1', name: 'Bob') }

  context 'when attributes are valid' do
    it { is_expected.to be_valid }
  end

  context 'when external_id is missing' do
    let(:player) { Player.new(external_id: nil) }
    it { expect(player).to be_invalid }
  end

  context 'when external_id is duplicated' do
    before { Player.create!(external_id: 'p1', name: 'Alice') }
    it { is_expected.to be_invalid }
  end
end
