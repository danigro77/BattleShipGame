FactoryGirl.define do
  factory :field do
    board { create(:board) }
    row_index (0..9).to_a.sample
    column_index (0..9).to_a.sample
    is_ship_field false
    is_uncovered false

    trait :with_ship do
      is_ship_field true
    end
    trait :is_uncovered do
      is_uncovered true
    end

    factory :ship_field, traits: [:with_ship]
    factory :uncovered_field, traits: [:is_uncovered]
    factory :uncovered_ship_field, traits: [:with_ship, :is_uncovered]

  end
end