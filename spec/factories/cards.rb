FactoryGirl.define do
  sequence :original_text do |n|
    "Привет#{n}"
  end

  sequence :translated_text do |n|
    "Hello#{n}"
  end

  factory :card do
    deck
    original_text
    translated_text
    review_date { 3.days.from_now }
    user
    attempts 0
    success 0

    trait :expired do
      review_date { 3.days.ago }
    end

    factory :expired_card, traits: [:expired]

    to_create {|instance| instance.save(validate: false) }
  end
end
