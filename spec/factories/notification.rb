# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    for_follow
    send_user factory: :user

    trait :for_follow do
      notification_type { :follow }
      target factory: :user
    end

    trait :for_like do
      notification_type { :like }
      target factory: :tweet
    end

    trait :for_comment do
      notification_type { :comment }
      target factory: :tweet
    end
  end
end
