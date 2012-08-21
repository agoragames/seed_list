FactoryGirl.define do
  factory :tournament
  factory :player do
    association :tournament
  end
end
