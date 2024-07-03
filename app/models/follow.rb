# frozen_string_literal: true

class Follow < ApplicationRecord
  has_many :notifications, as: :target, dependent: :destroy
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'

  validates :follower_id, uniqueness: { scope: :followed_id }

  def create_notification(current_user)
    existing_notification = followed.notifications.find_by(notification_type: :follow,
                                                           send_user: current_user)

    return if existing_notification

    followed.notifications.create!(notification_type: :follow,
                                   send_user: current_user,
                                   target: self)
  end
end
