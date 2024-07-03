# frozen_string_literal: true

class Favorite < ApplicationRecord
  has_many :notifications, as: :target, dependent: :destroy
  belongs_to :user
  belongs_to :tweet

  def create_notification(current_user)
    existing_notification = tweet.user.notifications.find_by(notification_type: :like,
                                                             send_user: current_user)

    return if existing_notification

    tweet.user.notifications.create!(notification_type: :like,
                                     send_user: current_user,
                                     target: self)
  end
end
