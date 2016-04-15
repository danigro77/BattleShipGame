FactoryGirl.define do
  factory :board do
    player { create(:player) }
    game { create(:game) }

  end
end