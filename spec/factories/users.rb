# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    provider { 'discord' }
    sequence(:uid) { |n| (1_234_567 + n).to_s }
    sequence(:name) { |n| "user#{n}" }
    discriminator { '1234' }
    admin { false }
    avatar { 'https://cdn.discordapp.com/embed/avatars/0.png' }

    trait :admin do
      admin { true }
    end

    trait :owner do
      owner { true }
    end

    factory :alice, aliases: [:user_alice] do
      uid { '1234567' }
      name { 'alice' }
      admin { true }
      avatar { 'https://cdn.discordapp.com/embed/avatars/3.png' }
    end

    factory :bob, aliases: [:user_bob] do
      uid { '2345678' }
      name { 'bob' }
      admin { false }
      avatar { 'https://cdn.discordapp.com/embed/avatars/1.png' }
    end
  end
end
