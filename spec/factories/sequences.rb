FactoryGirl.define do
  sequence :email do |i|
    "test#{i}@mail.ru"
  end
end
