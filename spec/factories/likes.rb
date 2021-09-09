FactoryBot.define do
  factory :michael_like, class: Like do
    association :user, factory: :michael
    association :micropost
  end
end
