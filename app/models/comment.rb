# frozen_string_literal: true

class Comment < ApplicationRecord
  include BodyValidation
  has_many :notifications, as: :target, dependent: :destroy
  belongs_to :tweet
  belongs_to :user

  validate_body_byte_size :body

  scope :recent, ->(offset, limit) { order(created_at: :desc).offset(offset).limit(limit) }

  def create_notification(current_user)
    tweet.user.notifications.create!(notification_type: :comment,
                                     send_user: current_user,
                                     target: self)
  end
end
