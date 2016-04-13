FactoryGirl.define do
  factory :game do
    player1 { create(:player) }
    player2 { create(:player) }

    trait :with_winner_p1 do
      after(:create) do |player, evaluator|
        player.winner = player.player1
      end
    end
    trait :with_winner_p2 do
      after(:create) do |player, evaluator|
        player.winner = player.player2
      end
    end

    factory :game_winner_p1, traits: [:with_winner_p1]
    factory :game_winner_p2, traits: [:with_winner_p2]
  end
end