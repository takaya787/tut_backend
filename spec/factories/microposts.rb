FactoryBot.define do
  factory :micropost do
    sequence(:content) { |n| "sample content no_#{n}" }
    association :user
  end

  factory :image_micropost, class: Micropost do
    sequence(:content) { |n| "sample content no_#{n}" }
    user

    after(:build) do |micropost|
      micropost.image.attach(io: File.open("spec/fixtures/image.png"), filename: "image.png", content_type: "image/png")
    end
  end
end
