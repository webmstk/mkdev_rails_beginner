FactoryGirl.define do
  factory :card do
    original_text 'Привет'
    translated_text 'Hello'
    review_date { Time.now }
  end
end