FactoryBot.define do
  factory :player do
    sequence(:external_id) { |n| "player_#{n}" }
    sequence(:name) { |n| "Player #{n}" }
  end
end
