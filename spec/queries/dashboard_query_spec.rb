# spec/queries/dashboard_query_spec.rb
require 'rails_helper'

RSpec.describe DashboardQuery, type: :query do
  describe '#call' do
    let(:player) { create(:player) }

    before do
      GameEvent.delete_all
      create(:game_event, event_type: 'BOSS_DEFEAT', value: 1000, player: player)
      create(:game_event, event_type: 'ITEM_PICKUP', value: 0, metadata: { item: 'potion' }, player: player)
    end

    subject(:stats) { described_class.new.call }

    it 'calculates total score ignoring null events' do
      expect(stats[:total_score]).to eq(1000)
    end
  end
end
