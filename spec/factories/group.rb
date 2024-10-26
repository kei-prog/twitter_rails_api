# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sender { association :user }
    recipient { association :user }
  end
end
