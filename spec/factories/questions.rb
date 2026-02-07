# frozen_string_literal: true

FactoryBot.define do
  factory :question do
    sequence(:body) { |n| "質問#{n}はなんですか？" }
  end
end
