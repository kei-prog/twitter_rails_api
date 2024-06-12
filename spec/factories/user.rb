# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { 'test' }
    email { 'test@example.com' }
    password { 'password' }
    password_confirmation { 'password' }
    birthday { '1990-01-01' }
    confirmed_at { Time.zone.now }
  end

  factory :tweet do
    body { 'FactoryBot Tweet' }
  end

  factory :comment do
    body { 'FactoryBot Comment' }
  end
end
