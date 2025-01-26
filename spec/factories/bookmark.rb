# frozen_string_literal: true

FactoryBot.define do
  factory :bookmark do
    user factory: :user
    tweet factory: :tweet
  end
end
