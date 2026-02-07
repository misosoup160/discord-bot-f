# frozen_string_literal: true

FactoryBot.define do
  factory :answer do
    user
    question
    sequence(:body) { |n| "回答#{n}です。" }
    posted { false }
    posted_at { nil }

    trait :posted do
      posted { true }
      posted_at { Time.current }
    end
  end
end
