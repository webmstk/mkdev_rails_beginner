FactoryGirl.define do
  factory :user do
    email
    password '123'
    password_confirmation '123'
  end
end
