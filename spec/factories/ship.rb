FactoryGirl.define do
  factory :ship, aliases: [:submarine] do
    board { create(:board) }
    ship_type 'submarine'
    size 1

    trait :for_aircraft_carrier do
      ship_type 'aircraft_carrier'
      size 5
    end
    trait :for_battleship do
      ship_type 'battleship'
      size 4
    end
    trait :for_cruiser do
      ship_type 'cruiser'
      size 3
    end
    trait :for_destroyer do
      ship_type 'destroyer'
      size 2
    end

    factory :aircraft_carrier, traits: [:for_aircraft_carrier]
    factory :battleship, traits: [:for_battleship]
    factory :cruiser, traits: [:for_cruiser]
    factory :destroyer, traits: [:for_destroyer]

    trait :sunken do
      sunk true
    end

    factory :sunken_ship, traits: [:sunken]

  end
end