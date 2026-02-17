FactoryBot.define do
  factory :game_event do
    category { "MyString" }
    event_type { "MyString" }
    occurred_at { "2026-02-17 01:42:10" }
    metadata { "" }
    player { nil }
  end
end
