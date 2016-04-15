FactoryGirl.define do
  factory :player do
    name { Faker::Internet.user_name }
    password 'password'
    logged_in true

    trait :not_logged_in do
      logged_in false
    end
    factory :offline_player, traits: [:not_logged_in]

    #  create(:player_with_initiated_games, game_count: 4)

    trait :with_active_initiated_games do
      ignore do
        game_count 2
      end
      after(:create) do |player, evaluator|
        create_list(:game, evaluator.game_count, player1: player)
      end
    end
    trait :with_active_invited_games do
      ignore do
        game_count 2
      end
      after(:create) do |player, evaluator|
        create_list(:game, evaluator.game_count, player2: player)
      end
    end

    factory :player_with_initiated_games, traits: [:with_active_initiated_games]
    factory :player_with_invited_games, traits: [:with_active_invited_games]

    trait :with_won_games do
      ignore do
        game_count 2
      end
      after(:create) do |player, evaluator|
        create_list(:game, evaluator.game_count, player1: player, winner: player)
      end
    end
    trait :with_lost_games do
      ignore do
        game_count 2
      end
      after(:create) do |player, evaluator|
        player2 = create(:player)
        create_list(:game, evaluator.game_count, player1: player2, player2: player, winner: player2)
      end
    end

    factory :player_with_won_games, traits: [:with_won_games]
    factory :player_with_lost_games, traits: [:with_lost_games]

    factory :player_with_game_mix, traits: [:with_active_initiated_games, :with_active_invited_games, :with_won_games, :with_lost_games]

    trait :with_boards do
      ignore do
        board_count 2
      end
      after(:create) do |player, evaluator|
        create_list(:board, evaluator.board_count, game: create(:game))
      end
    end
    factory :player_with_boards, traits: [:with_boards]

    trait :with_playing_game do
      playing_game { create(:game) }
    end
    factory :player_playing_game, traits: [:with_playing_game]



  end

end