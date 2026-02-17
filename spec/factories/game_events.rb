FactoryBot.define do
  factory :game_event do
    player
    event_type { "KILL" }
    value { 100 }
    category { "COMBAT" }
    occurred_at { Time.current }
  end
end
