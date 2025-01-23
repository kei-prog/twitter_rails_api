# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    group { association :group }
    sender { association :user }
    content { 'FactoryBot Content' }
  end
end
